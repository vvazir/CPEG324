
#include <stdio.h>
#include <string.h>

int main(int argsc, char *args[]){
	printf("Text entered: ");
	printf("%s\n", args[1]);

	char cmdi[4];
	char cmdo[2];

	char rg0i[3];
	char rg0o[3];
	
	char rg1i[3];
	char rg1o[3];
	
	char rg2i[3];
	char rg2o[3];
	
	char imm[5];

	char cmpjmp[2];
	
	char instructionOut[9];
	
	strncpy(cmdi, args[1], 3);
	cmdi[3] = '\0';

	strncpy(rg0i, args[2], 2);
	rg0i[2] = '\0';

	//Check the first register
	
	if((strcmp(rg0i,"r0") == 0)){
		strcpy(rg0o,"00");
	}//if

	else if((strcmp(rg0i,"r1") == 0)){
		strcpy(rg0o,"01");
	}//if

	else if((strcmp(rg0i,"r2") == 0)){
		strcpy(rg0o,"10");
	}//if	
	
	else if((strcmp(rg0i,"r3") == 0)){
		strcpy(rg0o,"11");
	}//if
	
	//check the command
	
	if ((strcmp(cmdi, "lod") == 0)){
		strcpy(cmdo,"00");
	}//if
	
	else if((strcmp(cmdi, "add") == 0)){
		strcpy(cmdo,"01");
	}//else if
	
	else if((strcmp(cmdi, "sub") == 0)){
		strcpy(cmdo,"10");
	}//else if
	
	else if((strcmp(cmdi, "dsp") == 0)){
		strcpy(cmdo,"11");
	}//else if
	
	else if((strcmp(cmdi, "cmp") == 0)){
		strcpy(cmdo,"11");
	}//else if
	
	//reading and converting now base on instruction
	
	if ((strcmp(cmdi, "lod") == 0)){
		strcpy(cmdo,"00");
		strncpy(imm, args[3], 4);
		imm[5] = '\0';
		instructionOut[0] = '\0';
		strcat(instructionOut,cmdo);
		strcat(instructionOut,rg0o);
		strcat(instructionOut,imm);
		instructionOut[8] = '\0';
	}//if
	 
	
	
	
	printf("Command in: %s\n",cmdi);
	printf("Register in: %s\n", rg0i);

	printf("Command out: %s\n",cmdo);
	printf("Register out: %s\n", rg0o);

	printf("imm is: %s\n", imm);
	
	printf("Final binary is: %s\n",instructionOut);
	
	return 0;

}//main 

//char* decode(char instr[8]){
//	char cmd[];
//	char rg1[];
//	char rg2[];
//	char rg3[];
//	char imm[];
//	strncpy(cmd, instr);
//	cmd[3] = '\0';
//	puts(cmd);
//	return cmd;
//}//decode
