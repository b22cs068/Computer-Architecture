#include <stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>

int main(){
           FILE *rd;
           char buffer[50];
           sprintf(buffer , "Hello Wolrd");
           rd= popen("wc -c", "w");
           fwrite(buffer, sizeof (char), strlen (buffer), rd);
           pclose(rd);
return 0;
}

