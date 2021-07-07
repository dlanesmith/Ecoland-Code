#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <math.h>
#include <dirent.h>
#include <sys/types.h>
#include <time.h>

void Format();
void Format2();
void printColumns();
void printColumnsMan();
void backupPoints();


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
            temp = strtok(NULL, ","); //To fix code
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
    FILE* f = fopen(fileNm, "a");
    for(int n = 0; n < i; n++){
        fprintf(f, "%.3f,", num1[n]);
        fprintf(f, "%.3f,", num2[n]);
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
        */
        st++;
        fprintf(f, "%.3f,", num1[n]);
        fprintf(f, "%.3f,", num2[n]);
        fprintf(f, "0.000\n");
    }
    fclose(f);
}

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

    FILE* f;
    char** m;
    m = (char **)malloc(sizeof(char*)*1);
    f = fopen("C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt", "r");
    m[0] = (char*)malloc(sizeof(char)*2);
    fgets(m[0], sizeof(m[0]), f);
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
    }

}

//C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\4901-base-eng-points.txt
