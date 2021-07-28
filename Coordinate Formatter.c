#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <math.h>
#include <dirent.h>
#include <sys/types.h>
#include <time.h>
#define _POSIX1_SOURCE 2
#include <unistd.h>
#include <fcntl.h>

void Format();
void Format2();
void printColumns();
void printColumnsMan();
void backupPoints();
void deletePoint();
void changeNum();
void movePoint();
void changeLine();
int doubleMag();
void insertLine();

int doubleMag(double n){
    int iN = (int) n;
    int i;
    int m = 1;
    for(i = 0; iN/m != 0; m *= 10){
        i++;
    }
    if(i == 0){
        i++;
    }
    if(n < 0){
        i++;
    }
    return i;
}

void movePoint(){ // Isn't working yet
    FILE* f;
    f = fopen("C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\CoordFile.txt", "r");
    char lin[100];
    fgets(lin, sizeof(lin), f);
    fgets(lin, sizeof(lin), f);
    fgets(lin, sizeof(lin), f);
    fgets(lin, sizeof(lin), f);
    fclose(f);
    double tem1;
    double tem2;
    double tem3;
    int z = 0;
    char* temp = (char *)malloc(sizeof(char)*100);
    char* temp2 = (char *)malloc(sizeof(char)*100);
    temp = strtok(lin, ",");
    temp = strtok(NULL, ",");
    tem1 = atof(temp);
    tem1 = round(tem1*1000)/1000;
    temp = strtok(NULL, ",");
    tem2 = atof(temp);
    tem2 = round(tem2*1000)/1000;
    temp = strtok(NULL, ",");
    if(temp != NULL){
        tem3 = atof(temp);
        tem3 = round(tem3*1000)/1000;
        z = 1;
    }
    int len1 = doubleMag(tem1)+5;
    printf("1d|%d|\n", len1);
    int len2 = doubleMag(tem2)+5;
    printf("2d|%d|\n", len2);
    int len3;
    if(z == 1){len3 = doubleMag(tem3)+4;}
    printf("b|%f|\n", tem1);
    printf("d|%f|\n", tem2);
    printf("f|%f|\n", tem3);
    char* crd = (char *)malloc(sizeof(char)*100);
    char* temp3 = (char *)malloc(sizeof(char)*100);
    sprintf(crd, "%.3f", tem2);
    printf("1s|%s|\n", crd);
    strcat(crd, ",");
    printf("2s|%s|\n", crd);
    sprintf(temp2, "%.3f", tem1);
    strcat(crd, temp2);
    printf("3s|%s|\n", crd);
    if(z == 1){
        snprintf(temp3, len3, "%lf", tem3);
        strcat(crd, ",");
        printf("4s|%s|\n", crd);
        strcat(crd, temp3);
        printf("5s|%s|\n", crd);
    } else{
        strcat(crd, ",0.000");
    }
    printf("|%s|\n", crd);
    changeLine(crd);
}


void changeNum(){
    int st;
    double* num1;
    double* num2;
    num1 = (double *)malloc(sizeof(double)*1000);//Change based on number of entries - This is the limit
    num2 = (double *)malloc(sizeof(double)*1000);
    printf("Input starting number: ");
    scanf("%d", &st);
    int loop = 1;
    int i = 0;
    for(; loop == 1; i++){
        char t[100];
        printf("Input coordinate or x: ");
        scanf("%s", t);
        if(t[0] == 'x'){
            loop = 0;
            i--;
        } else{
            double tem;
            char* temp = strtok(t, ",");
            temp = strtok(NULL, ","); //To fix code
            tem = atof(temp);
            num1[i] = round(tem*1000)/1000;
            temp = strtok(NULL, ",");
            tem = atof(temp);
            num2[i] = round(tem*1000)/1000;
        }
    }
    for(int n = 0; n < i; n++){
        printf("%d,", st);
        st++;
        printf("%.3f,", num1[n]);
        printf("%.3f,", num2[n]);
        printf("0.000\n");
    }
}

void changeLine(char* coord){
    FILE* f;
    FILE* ff;
    char lin[100];
    char** m;
    char** eLin;
    eLin = (char **)malloc(sizeof(char*)*5000);
    m = (char **)malloc(sizeof(char*)*2);
    f = fopen("C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt", "r");
    m[1] = (char*)malloc(sizeof(char)*100);
    fgets(m[1], 100, f);
    fgets(m[1], 100, f);
    int j = 0;
    for(; m[1][j] != '\n'; j++);
    m[1][j] = '\0';
    m[2] = (char *)malloc(sizeof(char)*100);
    fgets(m[2], 100, f);
    fclose(f);

    for(j = 0; m[2][j] != '.'; j++);
    m[2][j] = '\0';

    char fileNm[500] = "C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\";
    strcat(fileNm, m[2]);
    strcat(fileNm, "-points.txt");

    ff = fopen(fileNm, "r");
    int loop = 1;
    int bytes = 0;
    int k = 0;
    for(int i = 0; fgets(lin, sizeof(lin), ff) != NULL; i++){
        if(loop == 1){
            int tempb = strlen(lin);
            char* temp = strtok(lin, ",");
            if(strcmp(temp, m[1]) == 0){
                loop = 0;
            } else {
                bytes += (tempb + 1);
            }
        } else {
            eLin[k] = (char *)malloc(sizeof(char)*200);
            strcpy(eLin[k], lin);
            k++;
        }
    }
    fclose(ff);
    int tf = open(fileNm, O_RDWR);
    ftruncate(tf, bytes);
    ff = fopen(fileNm, "a");
    if(strcmp(coord, "") != 0){
        strcat(m[1], ",");
        strcat(m[1], coord);
        fprintf(ff, "%s\n", m[1]);
    }
    for(int n = 0; n < k; n++){
        fprintf(ff, "%s", eLin[n]);
    }
    fclose(ff);
}

void deletePoint(){
    FILE* f;
    FILE* ff;
    FILE* df;
    char lin[100];
    int chk = 0;
    char** m;
    char** eLin;
    m = (char **)malloc(sizeof(char*)*2);
    f = fopen("C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt", "r");
    m[1] = (char*)malloc(sizeof(char)*100);
    fgets(m[1], 100, f);
    fgets(m[1], 100, f);
    int j = 0;
    for(; m[1][j] != '\n'; j++);
    m[1][j] = '\0';
    m[2] = (char*)malloc(sizeof(char)*100);
    fgets(m[2], 100, f);
    fclose(f);

    for(j = 0; m[2][j] != '.'; j++);
    m[2][j] = '\0';

    changeLine("");

    char fileNm[500];
    strcpy(fileNm, "C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\Deleted Points\\");
    strcat(fileNm, m[2]);
    strcat(fileNm, "-deleted points.txt");
    df = fopen(fileNm, "r");
    int i = 0;
    for(; fgets(lin, sizeof(lin), df) != NULL; i++){
        if(atoi(m[1]) < atoi(lin) && chk == 0){
            eLin[i] = (char *)malloc(sizeof(char)*10);
            strcpy(eLin[i], m[1]);
            int z;
            for(z = 0; eLin[i][z] != '\0'; z++);
            eLin[i][z] = '\n';
            eLin[i][z+1] = '\0';
            chk = 1;
            i++;
        }
        eLin[i] = (char *)malloc(sizeof(char)*10);
        strcpy(eLin[i], lin);
    }
    if(chk == 0){
        eLin[i] = (char *)malloc(sizeof(char)*10);
        strcpy(eLin[i], m[1]);
        int z;
        for(z = 0; eLin[i][z] != '\0'; z++);
        eLin[i][z] = '\n';
        eLin[i][z+1] = '\0';
        i++;
    }
    eLin[i] = (char *)malloc(sizeof(char)*200);
    char mrk[4] = "end";
    strcpy(eLin[i], mrk);
    fclose(df);
    df = fopen(fileNm, "w");
    if(strcmp(eLin[0], mrk) == 0){
        fprintf(df, "%s\n", m[1]);
    } else{
        for(i = 0; strcmp(eLin[i], mrk) != 0; i++){
            fprintf(df, "%s", eLin[i]);
        }
    }
    fclose(df);
}

void backupPoints(){
    time_t t = time(NULL);
    struct tm tm = *localtime(&t);
    char source[200];
    char dest[200];
    char str[400];
    char datT[100];
    sprintf(datT, " - %d-%02d-%02d %02d_%02d_%02d", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);
    strcpy(source, "C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points");
    strcpy(dest, "C:\\Users\\Ecoland\\Documents\\Backup Files\\Backup Points\\Points");
    strcat(dest, datT);
    mkdir(dest);
    sprintf(str, "XCOPY \"%s\" \"%s\" /I/-Y", source, dest);
    system(str);
}

void Format2(){
    int i = 0;
    int loop = 1;
    double* num1;
    double* num2;
    double* num3;
    num1 = (double *)malloc(sizeof(double)*1000);//Change based on number of entries - This is the limit
    num2 = (double *)malloc(sizeof(double)*1000);
    num3 = (double *)malloc(sizeof(double)*1000);
    for(int j = 0; loop == 1; j++){
        char t[100];
        printf("Input coordinate or x: ");
        scanf("%s", t);
        printf("\n\n\n%s\n\n\n", t);
        if(t[0] == 'x'){
            loop = 0;
            i--;
        } else if (strchr("1234567890", t[0]) != NULL){
            double tem;
            char* temp = strtok(t, ",");
            //temp = strtok(NULL, ","); //To fix code
            tem = atof(temp);
            num1[i] = round(tem*1000)/1000;
            temp = strtok(NULL, ",");
            tem = atof(temp);
            num2[i] = round(tem*1000)/1000;
            temp = strtok(NULL, ",");
            tem = atof(temp);
            num3[i] = round(tem*1000)/1000;
            i++;
        }
    }
    char fileNm[500] = "C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\Formatted Points.txt";
    FILE* f = fopen(fileNm, "w");
    for(int n = 0; n < i; n++){
        fprintf(f, "%.3f,", num2[n]);
        fprintf(f, "%.3f,", num1[n]);
        fprintf(f, "%.3f\n", num3[n]);
    }
    fclose(f);
}

void Format(){
    int loop = 1;
    int chk = 0;
    FILE *f;
    int st;
    char lin[100];
    char out[10];
    char fName[100];
    f = fopen("C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\CoordFile.txt", "r");
    fgets(lin, sizeof(lin), f);
    int j = 0;
    for(; lin[j] != '\n'; j++){
       out[j] = lin[j];
    }
    out[j] = '\0';
    fgets(lin, sizeof(lin), f);
    for(j = 0; lin[j] != '.'; j++){
       fName[j] = lin[j];
    }
    fName[j] = '\0';
    double* num1;
    double* num2;
    double* num3;
    char** lbl;
    num1 = (double *)malloc(sizeof(double)*1000);//Change based on number of entries - This is the limit
    num2 = (double *)malloc(sizeof(double)*1000);
    num3 = (double *)malloc(sizeof(double)*1000);
    lbl = (char **)malloc(sizeof(char *)*1000);
    int i = 0;
    int z = 0;
    fgets(lin, sizeof(lin), f);
    for(; fgets(lin, sizeof(lin), f) != NULL; i++){
        double tem;
        char* temp = (char *)malloc(sizeof(char)*100);
        temp = strtok(lin, ",");
        lbl[i] = (char *)malloc(sizeof(char)*50);
        printf("loop\n");
        lbl[i][j] = '\0';
        strcpy(lbl[i], temp);
        temp = strtok(NULL, ",");
        tem = atof(temp);
        num2[i] = round(tem*1000)/1000;
        temp = strtok(NULL, ",");
        tem = atof(temp);
        num1[i] = round(tem*1000)/1000;
        printf("N: %s\n", lbl[i]);
        temp = strtok(NULL, ",");
        if(temp != NULL){
            tem = atof(temp);
            num3[i] = round(tem*1000)/1000;
            z = 1;
        }
    }
    fclose(f);
    char pref[500] = "C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\";
    char *fileNm = (char *)malloc(sizeof(char)*500);
    fileNm = strcat(pref, fName);
    if(out[0] == '0'){
        fileNm = strcat(fileNm, "-points.txt");
    } else{
        fileNm = strcat(fileNm, "-custom points.txt");
    }
    char coord[100];
    char temp[100];
    f = fopen(fileNm, "r");
    char finL[100];
    while(fgets(lin, sizeof(lin), f) != NULL){
        strcpy(finL, strtok(lin, ","));
    }
    fclose(f);
    for(int n = 0; n < i; n++){
        sprintf(coord, "%s,", lbl[n]);
        sprintf(temp, "%.3f,", num1[n]);
        strcat(coord, temp);
        sprintf(temp, "%.3f,", num2[n]);
        strcat(coord, temp);
        if(z == 1){
            sprintf(temp, "%.3f\n", num3[n]);
            strcat(coord, temp);
        }
        else{
            sprintf(temp, "0.000\n");
            strcat(coord, temp);
        }
        if(atoi(lbl[n]) < atoi(finL)){
            insertLine(coord, fileNm);
        } else{
            f = fopen(fileNm, "a");
            fprintf(f, "%s", coord);
            fclose(f);
        }

    }
}

void insertLine(char* coord, char* fileNm){
    char pCoord[100];
    strcpy(pCoord, coord);
    FILE* ff;
    char lin[100];
    char lbl[10];
    char** eLin;
    eLin = (char **)malloc(sizeof(char*)*5000);
    strcpy(lbl,strtok(coord, ","));
    int lblN = atoi(lbl);

    ff = fopen(fileNm, "r");
    int loop = 1;
    int bytes = 0;
    int k = 0;
    for(int i = 0; fgets(lin, sizeof(lin), ff) != NULL; i++){
        if(loop == 1){
            int tempb = strlen(lin);
            char clin[100];
            strcpy(clin, lin);
            char* temp = strtok(clin, ",");
            int tempN = atoi(temp);
            if(tempN > lblN){
                loop = 0;
                eLin[k] = (char *)malloc(sizeof(char)*200);
                strcpy(eLin[k], lin);
                k++;
            } else {
                bytes += (tempb + 1);
            }
        } else {
            eLin[k] = (char *)malloc(sizeof(char)*200);
            strcpy(eLin[k], lin);
            k++;
        }
    }
    fclose(ff);
    int tf = open(fileNm, O_RDWR);
    ftruncate(tf, bytes);
    ff = fopen(fileNm, "a");
    fprintf(ff, "%s", pCoord);
    for(int n = 0; n < k; n++){
        fprintf(ff, "%s", eLin[n]);
    }
    fclose(ff);
}

/*
void Format(){
    int loop = 1;
    int chk = 0;
    FILE *f;
    int st;
    char lin[100];
    char out[10];
    char fName[100];
    f = fopen("C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\CoordFile.txt", "r");
    //f = NULL; //To manually input
    if(f == NULL){
        printf("Input starting number: ");
        scanf("%d", &st);
        chk = 1;
    } else {
        fgets(lin, sizeof(lin), f);
        for(int j = 16; lin[j] != '\n'; j++){
           out[j-16] = lin[j];
        }
        fgets(lin, sizeof(lin), f);
        int j = 0;
        for(; lin[j] != '.'; j++){
           fName[j] = lin[j];
        }
        fName[j] = '\0';
        st = atoi(out);
    }
    double* num1;
    double* num2;
    num1 = (double *)malloc(sizeof(double)*1000);//Change based on number of entries - This is the limit
    num2 = (double *)malloc(sizeof(double)*1000);
    int i = 0;
    if(chk == 1){
        for(; loop == 1; i++){
            char t[100];
            printf("Input coordinate or x: ");
            scanf("%s", t);
            if(t[0] == 'x'){
                loop = 0;
                i--;
            } else{
                double tem;
                char* temp = strtok(t, ",");
                //temp = strtok(NULL, ","); //To fix code
                tem = atof(temp);
                num1[i] = round(tem*1000)/1000;
                temp = strtok(NULL, ",");
                tem = atof(temp);
                num2[i] = round(tem*1000)/1000;
            }
        }
    } else{
        fgets(lin, sizeof(lin), f);
        for(; fgets(lin, sizeof(lin), f) != NULL; i++){
            double tem;
            char* temp = strtok(lin, ",");
            //temp = strtok(NULL, ","); //To fix code
            tem = atof(temp);
            num2[i] = round(tem*1000)/1000;
            temp = strtok(NULL, ",");
            tem = atof(temp);
            num1[i] = round(tem*1000)/1000;
        }
    }
    fclose(f);
    char pref[500] = "C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\";
    char *fileNm = (char *)malloc(sizeof(char)*500);
    fileNm = strcat(pref, fName);
    fileNm = strcat(fileNm, "-points.txt");
    f = fopen(fileNm, "a");
    for(int n = 0; n < i; n++){
        fprintf(f, "%d,", st);
        /* -- For 4901-base-eng --
        int not[40] = {13,11,17,20,24,26,28,30,35,38,40,43,44,46,48,52,54,57,59,60,63,64,70,73,77,82,85,87,94,96,99,101,104,105,109,112,122,519,0};
        int con = 1;
        while(con == 1){
            st++;
            con = 0;
            for(int m = 0; not[m] != 0; m++){
                if(st == not[m]){
                    con = 1;
                }
            }
        }

        st++;
        fprintf(f, "%.3f,", num1[n]);
        fprintf(f, "%.3f,", num2[n]);
        fprintf(f, "0.000\n");
    }
    fclose(f);
}
*/

void printColumns(){
    char fn[100];
    //printf("Input file path of coordinates text file: ");
    //scanf("%s", fn);
    FILE *f;
    f = fopen("C:\\Users\\Ecoland\\Documents\\Point Drawings\\Printing File.txt", "r");
    char temp[100];
    char** lin;
    lin = (char **)malloc(sizeof(char*)*1000);
    int len = 0;
    for(; (fgets(temp, sizeof(temp), f) != NULL) && (len < 1000); len++){
        lin[len] = (char*)malloc(sizeof(char)*100);
        strcpy(lin[len], temp);
    }
    fclose(f);
    double pr = 0;
    int i = 0;
    for(int a = 0; a < len; a++){
        for(int b = 0; lin[a][b] != '\0' ; b++){
            if(lin[a][b] == '\n'){
                lin[a][b] = '\0';
                break;
            }
        }
    }
    f = fopen("C:\\Users\\Ecoland\\Documents\\Point Drawings\\Column File.txt", "w");
    for(; i < floor(len/100) ; i++){
        for(int j = 0; j < 50; j++){
            fprintf(f, "%s         %s\n", lin[j+(i*100)], lin[j+(i*100)+50]);
        }
        pr += 100;
    }
    int intrvl = (int) floor(len-pr);
    intrvl = (int) (intrvl/2.0);
    for(int k = 0; k < intrvl; k++){
        fprintf(f, "%s         %s\n", lin[k+(i*100)], lin[k+(i*100)+intrvl+1]);
    }
    if(((int) (len-pr))%2 == 1){
        fprintf(f, "%s\n", lin[intrvl+(i*100)]);
    }
    fclose(f);
}

void printColumnsMan(){
    int loop = 1;
    char** firC = (char**)malloc(sizeof(char*)*1000);
    char** secC = (char**)malloc(sizeof(char*)*1000);
    int i = 0;
    for(; loop == 1; i++){
        char t[100];
        printf("Input first column or x: ");
        scanf("%s", t);
        if(t[0] == 'x'){
            loop = 0;
            i--;
        } else{
            firC[i] = (char*)malloc(sizeof(char)*100);
            strcpy(firC[i],t);
        }
    }
    int j = 0;
    loop = 1;
    for(; loop == 1; j++){
        char t[100];
        printf("Input second column or x: ");
        scanf("%s", t);
        if(t[0] == 'x'){
            loop = 0;
            j--;
        } else{
            secC[j] = (char*)malloc(sizeof(char)*100);
            strcpy(secC[j],t);
        }
    }
    printf("\n%d, %d\n", i, j);
    if(i > j){
        for(int a = 0; a < i; a++){
            if(a >= j){
                secC[a] = " ";
            }
        }
    }
    if(j > i){
        for(int a = 0; a < j; a++){
            if(a >= i){
                firC[a] = "                                 ";
            }
        }
    }


    FILE* f = fopen("C:\\Users\\Ecoland\\Documents\\Point Drawings\\Column File.txt", "w");
    for(int a = 0; (a < j) || (a < i) ; a++){
        fprintf(f, "%s", firC[a]);
        int spc = 45 - strlen(firC[a]);
        for(int b = 0; b < spc; b++){
            fprintf(f, " ");
        }
        fprintf(f, "%s\n", secC[a]);
    }
    fclose(f);
}

int main(){
    //Format();
    //Format2();
    //printColumns();
    //printColumnsMan();
    //backupPoints();
    //deletePoint();

    //changeNum();


    FILE* f;
    char** m;
    m = (char **)malloc(sizeof(char*)*1);
    f = fopen("C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt", "r");
    m[0] = (char*)malloc(sizeof(char)*2);
    fgets(m[0], 2, f);
    fclose(f);
    if(m[0][0] == '0'){
        Format();
    } else if(m[0][0] == '1'){
        Format2();
    } else if(m[0][0] == '2'){
        printColumns();
    } else if(m[0][0] == '3'){
        printColumnsMan();
    } else if(m[0][0] == '4'){
        backupPoints();
    } else if(m[0][0] == '5'){
        deletePoint();
    } else if(m[0][0] == '6'){
        movePoint();
    }
    /* */
}

//C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\4901-base-eng-points.txt
