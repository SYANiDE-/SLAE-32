#include <stdlib.h>
#include <stdio.h>


int main(){
	unsigned int i = 16614;   //0x40e6
	unsigned char *HWStr = ": Hello ASM World!";
	unsigned char *FmtStr = "%d%s\n";
	unsigned int Count;
	while(i-- != 0){
		Count++; 
		printf(FmtStr, Count, HWStr);
	}
	exit(0);
}
