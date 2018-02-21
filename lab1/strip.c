/* strtok example */
#include <stdio.h>
#include <string.h>

/*
lod r1 0101
add r1 r2 r3
sub r1 r2 r3
cmp r1 r2 1
dsp r1

*/

char* stripInstruction(char** arg,char* inputStr);

int main (){
	char* ins;
	char* args[4];
	char str[] = "add r1, r2 ,r3";
	ins  = stripInstruction(args,str);
	printf("%s",args[0]);
  return 0;
}//main

char* stripInstruction(char** arg, char* inputStr){
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
		  }//if
		  
		  index = 0;
		  
		  while(index < 4){
			printf("%s\n",arg[index]);
			index++;
		  }//while
}//strip
