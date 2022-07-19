#define buf_len 5000
#define disk_size 16

void print_disk (char * dk, int isData){
	if (isData){
		char tmps[5]="";	
		sscanf(dk,"%4s",tmps);
		printf("\t%s\t",tmps);
	}
	else{
		int tmphex = * (int*)dk;
		printf("\t%x\t",tmphex);
	}
}

int main(){
	char * buffer = malloc(buf_len * sizeof(char));
	char * d1 = malloc (disk_size * sizeof (char));
	char * d2 = malloc (disk_size * sizeof (char));
	char * d3 = malloc (disk_size * sizeof (char));

	int* md1 = (int*)d1, * md2 = (int*)d2, *md3 = (int*)d3; * mbuffer = (int*) buffer;
	do{
		printf("Nhap chuoi:");
		int len = scanf ("%s",buffer);
	}while (len % 8 != 0);
	len = len/8;
	int i1,i2,i3,bkd =0;
	for (int i =0;i<len;i++){
		i1 = * (mbuffer++);
		i2 = * (mbuffer++);
		i3 = i1 ^ i2;
		switch bkd:
			case 0:
				*md1 = i1; *md2 = i2; *md3 = i3;
				break;
			case 1:
				*md1 = i1; *md2 = i3; *md3 = i2;
				break;
			case 2:
				*md1 = i3; *md2 = i1; *md3 = i2;
				break;
		print_disk((char*)md1,bkd != 1);
		print_disk((char*)md2,bkd != 2);
		print_disk((char*)md3,bkd != 0);
		printf("\n");
		md1++;md2++;md3++;
		if (--bkd <0){bkd =2;}
	}
	
}