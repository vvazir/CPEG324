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

void lod(struct Ins ins);
int ipow(int base, int exp);

void main(int argc, char *argv[]){

	struct Ins ins;	
	strcpy(ins.r1,"r0");
	strcpy(ins.imm,"0111");
	lod(ins);
	
}//main

void lod(struct Ins ins){
	int immInt = 0;
	int isNeg = 0;
	int carry = 0;
	
	//check for negative
	if (ins.imm[0] == '1'){
		isNeg = 1;
	}//if
	
	//two's compliment time
	if (isNeg == 1){
		
		//First we flip
		for(int i = 3; i >= 0 ; i--){	
			if (ins.imm[i] == '1'){
				ins.imm[i] = '0';
			}//if
			
			else if(ins.imm[i] == '0'){
				ins.imm[i] = '1';
			}//else
				
		}//for
		
		//now add one
		//LSB == 0 case first
		if (ins.imm[3] == '0'){
			ins.imm[3] = '1';
		}//if

		//Now if the LSB == 1
		else if (ins.imm[3] == '1'){
			ins.imm[3] = '0';
			carry = 1;
			int i = 2; 
		
			//changing the bits as long as the carry == 1
			while ((carry == 1) && (i >= 0)){

				if (ins.imm[i] == '1'){
					ins.imm[i] = '0';
					carry = 1;
				}//if
			
				else if(ins.imm[i] == '0'){
					ins.imm[i] = '1';
					carry = 0;
				
				}//else if
			i--;

			}//while
		
		}//else if
	
	}//if
	
	//converting to decimal
	for(int i = 3; i >0 ; i--){

		if (ins.imm[i] == '1'){
			immInt += ipow(2,3-i);
		}//if
				
	}//for
	
	//handling MSB and negativity
	if(isNeg == 1){
		if(strcmp(ins.imm,"1000") == 0){
			immInt = 8;
		}//if
		immInt = 0-immInt;
	}//if
	
	
	//storing in appropriate register
	if (strcmp(ins.r1,"r0") == 0){
		r0 = immInt;
	}//if r0
	
	else if (strcmp(ins.r1,"r1") == 0){
		r1 = immInt;
	}//else if r1
	
	else if (strcmp(ins.r1,"r2") == 0){
		r2 = immInt;
	}//else if r2
	
	else if (strcmp(ins.r1,"r3") == 0){
		r3 = immInt;
	}//else if r3
	
}//lod 

int ipow(int base, int exp){
    int result = 1;
    while (exp){
        if (exp & 1)
            result *= base;
        exp >>= 1;
        base *= base;
    }//while

    return result;
}//ipow