#include <stdio.h>
#include <stdlib.h>

    /*data*/ char buffer[44];
    char num_of_students[]="enter number of students : ";
    char enter_name[]= "enter your name : ";
	char enter_score[]= "enter your score : ";
	char enter[]= "\n";
int main (){


    printf("%s",num_of_students);

    int n; // $t0 
    scanf("%d",&n);  
    

    //malloc
    
    int * point = malloc(n* sizeof(int));





    char * name = malloc(n*40 *sizeof(char));





    int *mpoint = point;
    char *mname = name;


    
    
    
    //input loop
    for(int i = 0;i<n;i++){




        printf("%s",enter_name);




        scanf("%s",mname);













        // input check 
        do{
            printf("%s",enter_score);



        
        
        
            scanf("%d",mpoint);
        }while(*mpoint <0||*mpoint>10);
        






        //move pointer
        mname +=40;
        mpoint +=1;
    }









    //sort using pointer
    char tmpc;
    int tmpi1,tmpi2;
    //sort from here
    int *mpoint = point;
    char *mname = name;
    for (int i=0;i<n;i++){
        

        tmpi1 = *(mpoint+i);




        for (int j=i+1;j<n;j++){
            
            
            
            
            
            
            tmpi2= *(mpoint+j);

            
            //switch
            if (tmpi1<tmpi2){
                //switch point;
                *(mpoint+i)=tmpi2;
                *(mpoint+j)=tmpi1;
                tmpi1 = *(mpoint+i);
                tmpi2= *(mpoint+j);

                //switch name
                for (int k=0;k<40;k++){
                    tmpc= *(mname+i+k);
                    *(mname+i+k) =*(mname+j+k);
                    *(mname+j+k) = tmpc;
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    








  
    //print
    int *mpoint = point;
    char *mname = name;
    for (int i=0;i<n;i++){
        printf("%s%d",mname+i*40,*(mpoint+i));

    }
}