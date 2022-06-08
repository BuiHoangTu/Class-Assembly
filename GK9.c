#include <stdio.h>

// .Data
	#define NUM_OF_STUDENTS	2
	char	Name[][40] = {"Mai Nguyen Ngoc Huy","Bui Hoang Tu"};
	int 	Score[]	=	{5,9};
	






int main() {
	// Procedure to save the Minimum Score required to pass the exam
	
	printf("Minimum Score Require : ");
	int m;
	scanf("%d", &m);
	int n = NUM_OF_STUDENTS;

		// print name
	printf("\n List the names of all students who have not passed the Math exam : \n ");
	for(int i = 0; i < n; i++) {
		if (Score[i] < m) {
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			printf(" %d. %s %d", i+1, Name[i], Score[i]);
		}
	}
}
