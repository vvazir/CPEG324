
#include <stdio.h>
#include <string.h>

void decode(char *args[]);
void stripInstruction(char** arg,char* inputStr);

int main(int argsc, char *arg[]){
	if(arg[1] == NULL){
		printf("Please enter a valid command\n");
		return 0;
	}//if
	
	char* strpIns;
	char* strpArgs[4];
	char* str = arg[1];
	
	stripInstruction(strpArgs,str);

	/*
	for(int i = 0; i < 4;i++){
		printf("%s\n",strpArgs[i]);
	}//for
	*/
	
	decode(strpArgs);
	
	return 0;
}//main 

void decode(char *args[]){
		
		//Set up variables		
		char cmdi[4];	//command in
		char cmdo[2];	//command out

		char rg0i[3];	//destination register in
		char rg0o[3];	//destination register out
		
		char rg1i[3];	//source register in
		char rg1o[3];	//source register out
		
		char rg2i[3];	//target register in
		char rg2o[3];	//target register out
		
		char imm[5];	//immediate value
		strcpy(imm,"none"); //initialize to "none"

		char jmpi[2];	//jump amount in
		char jmpo[3];	//jump amount out
		
		char instructionOut[9];		//binary instruction out
		instructionOut[0] = '\0';	//start with null
		
		strcpy(cmdi, args[0]);
		cmdi[3] = '\0';

		strcpy(rg0i, args[1]);
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
		
		if ((strcmp(cmdi,"lod") == 0)){			//lod
			strcpy(imm, args[2]);
			imm[5] = '\0';
		
			strcat(instructionOut,cmdo);
			strcat(instructionOut,rg0o);
			strcat(instructionOut,imm);
			instructionOut[8] = '\0';
		}//if load case
		
		else if ((strcmp(cmdi, "add") == 0) || (strcmp(cmdi, "sub") == 0)){ 	//add or sub
			strcpy(rg1i, args[2]);
			rg1i[2] = '\0';
			
			strcpy(rg2i, args[3]);
			rg2i[2] = '\0';
			
			//read in 2nd register
			
			if((strcmp(rg1i,"r0") == 0)){
				strcpy(rg1o,"00");
			}//if

			else if((strcmp(rg1i,"r1") == 0)){
				strcpy(rg1o,"01");
			}//if

			else if((strcmp(rg1i,"r2") == 0)){
				strcpy(rg1o,"10");
			}//if	
		
			else if((strcmp(rg1i,"r3") == 0)){
				strcpy(rg1o,"11");
			}//if

			//read in 3rd register
			
			if((strcmp(rg2i,"r0") == 0)){
				strcpy(rg2o,"00");
			}//if

			else if((strcmp(rg2i,"r1") == 0)){
				strcpy(rg2o,"01");
			}//else if

			else if((strcmp(rg2i,"r2") == 0)){
				strcpy(rg2o,"10");
			}//else if	
		
			else if((strcmp(rg2i,"r3") == 0)){
				strcpy(rg2o,"11");
			}//else if
			
			strcat(instructionOut,cmdo);
			strcat(instructionOut,rg0o);
			strcat(instructionOut,rg1o);
			strcat(instructionOut,rg2o);		
		
		}//else if add or sub
		
		else if ((strcmp(cmdi, "cmp") == 0)){ 	//cmp
			strcpy(rg1i, args[2]);
			rg1i[2] = '\0';

			//read in 2nd register
			
			if((strcmp(rg1i,"r0") == 0)){
				strcpy(rg1o,"00");
			}//if

			else if((strcmp(rg1i,"r1") == 0)){
				strcpy(rg1o,"01");
			}//if

			else if((strcmp(rg1i,"r2") == 0)){
				strcpy(rg1o,"10");
			}//if	
		
			else if((strcmp(rg1i,"r3") == 0)){
				strcpy(rg1o,"11");
			}//if

			
			strcpy(jmpi, args[3]);
			jmpi[1] = '\0';
			
			//checking for number of lines to skip
			if ((strcmp(jmpi,"1") == 0)){
				strcpy(jmpo,"01");
			}//if
			
			else if((strcmp(jmpi,"2") == 0)){
				strcpy(jmpo,"10");
			}//else if
			
			strcat(instructionOut,cmdo);
			strcat(instructionOut,rg0o);
			strcat(instructionOut,rg1o);
			strcat(instructionOut,jmpo);		
			
		}//else if cmp
		
		
		else if ((strcmp(cmdi, "dsp") == 0)){ 	//dsp
			strcat(instructionOut,cmdo);
			strcat(instructionOut,rg0o);
			strcat(instructionOut,"0000");		
			
		}//else if dsp
		
		/*
		printf("Command in: %s\n",cmdi);
		printf("Register in: %s\n\n", rg0i);

		printf("Command out: %s\n",cmdo);
		printf("Register out: %s\n\n", rg0o);

		printf("imm is: %s\n\n", imm);
		*/
		printf("Final binary is: %s\n",instructionOut);
		
}//decode()


void stripInstruction(char** arg, char* inputStr){
		  char * instr;
		  int index = 0;
		  
		  instr = strtok (inputStr," ,.-");
		  
		  while (instr != NULL){
			arg[index] = instr;
			instr = strtok (NULL, " ,.-");
			index++;
		  }//while
		  
		  while (index < 4){
				arg[index] = " ";
				index++;
		  }//while

}//strip
