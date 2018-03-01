#include <stdio.h>
#include <string.h>

// Data type
struct Ins {
	char op[4];
	char r1[3];
	char r2[3];
	char r3[3];
	char imm[5];
	char jmp[2];
};



int r0=0;
int r1=0;
int r2=0;
int r3=0;
int pc=0;

void dsp(struct Ins ins);

void main(int argc, char *argv[]){

	struct Ins ins;	
	
	r0=1;
	r1=2;
	r2=3;
	r3=4;
	
	strcpy(ins.r1,"r0");
	strcpy(ins.r2,"r1");
	strcpy(ins.r3,"r2");
	
	dsp(ins);
	
}//main

void dsp(struct Ins ins){
	if (strcmp(ins.r1,"r0") == 0){
		printf("%d\n",r0);
	}//if r0
	
	else if (strcmp(ins.r1,"r1") == 0){
		printf("%d\n",r1);
	}//else if r1
	
	else if (strcmp(ins.r1,"r2") == 0){
		printf("%d\n",r2);
	}//else if r2
	
	else if (strcmp(ins.r1,"r3") == 0){
		printf("%d\n",r3);
	}//else if r3

}//dsp
