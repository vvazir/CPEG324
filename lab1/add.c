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

void add(struct Ins ins);

void main(int argc, char *argv[]){

	struct Ins ins;	
	
	r0=1;
	r1=2;
	r2=3;
	r3=4;
	
	strcpy(ins.r1,"r2");
	strcpy(ins.r2,"r1");
	strcpy(ins.r3,"r2");
	
	add(ins);
	
	printf("r0 = %d\n",r0);
	printf("r1 = %d\n",r1);
	printf("r2 = %d\n",r2);
	printf("r3 = %d\n",r3);
	
}//main

void add(struct Ins ins){
	int reg2;
	int reg3;
	int sum;
	
	if (strcmp(ins.r2,"r0") == 0){
		reg2 = r0;
	}//if r0
	
	else if (strcmp(ins.r2,"r1") == 0){
		reg2 = r1;
	}//else if r1
	
	else if (strcmp(ins.r2,"r2") == 0){
		reg2 = r2;
	}//else if r2
	
	else if (strcmp(ins.r2,"r3") == 0){
		reg2 = r3;
	}//else if r3

	if (strcmp(ins.r3,"r0") == 0){
		reg3 = r0;
	}//if r0
	
	else if (strcmp(ins.r3,"r1") == 0){
		reg3 = r1;
	}//else if r1
	
	else if (strcmp(ins.r3,"r2") == 0){
		reg3 = r2;
	}//else if r2
	
	else if (strcmp(ins.r3,"r3") == 0){
		reg3 = r3;
	}//else if r3
	
	sum = reg2 + reg3;
	
	if (strcmp(ins.r1,"r0") == 0){
		r0 = sum;
	}//if r0
	
	else if (strcmp(ins.r1,"r1") == 0){
		r1 = sum;
	}//else if r1
	
	else if (strcmp(ins.r1,"r2") == 0){
		r2 = sum;
	}//else if r2
	
	else if (strcmp(ins.r1,"r3") == 0){
		r3 = sum;
	}//else if r3
		
	
}//add 
