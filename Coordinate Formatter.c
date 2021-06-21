#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <math.h>

void Format();
void printColumns();

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
                num2[i] = round(tem*1000)/1000;
                temp = strtok(NULL, ",");
                tem = atof(temp);
                num1[i] = round(tem*1000)/1000;
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
    f = fopen("C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\4901-base-eng-points.txt", "r");
    char temp[100];
    char** lin;
    lin = (char **)malloc(sizeof(char*)*1000);
    int len = 0;
    for(; (fgets(temp, sizeof(temp), f) != NULL) || (len < 1000); len++){
        lin[len] = (char*)malloc(sizeof(char)*100);
        strcpy(lin[len], temp);
        printf("%s", lin[len]);
    }
    printf("\n\nYep\n\n");
    double pr = 0;
    int i = 0;
    for(; i < (len%100) ; i++){
        for(int j = 0; j < 50; j++){
            printf("%s         %s\n", lin[j+(i*100)], lin[j+(i*100)+50]);
        }
        pr += 100;
    }
    int intrvl = (int) floor(len-pr);
    for(int k = 0; k < intrvl; k++){
        printf("%s         %s\n", lin[k+(i*100)], lin[k+(i*100)+intrvl]);
    }
    if(((int) (len-pr))%2 == 1){
        printf("%s\n", lin[len-1]);
    }
}

int main(){
    Format();
    //printColumns();
    /*char str1[500] = "2020-02-20 Seneca Creek Enhancement and Modifications(feb-2020)WRK-points";
    char str2[500] = "2020-02-20 Seneca Creek Enhancement and Modifications(feb-2020)WRK-points";
    int bo = strcmp(str1, str2);*/
}

//C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\4901-base-eng-points.txt
