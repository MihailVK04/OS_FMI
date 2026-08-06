#include <err.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdlib.h>

int wrapper_read(int fd, void* buff, int size) {
    int r = read(fd,buff,size);
    if (r<0) {
        err(1,"Error reading");
    }
    return r;
}

int wrapped_write(int fd, const void* buff, int size) {
    int w = write(fd,buff,size);
    if (w<0) {
        err(2,"Error writing");
    }
    return w;
}

void cOption(int start, int end) {
    char ch;
    int i=1;
    while(wrapped_read(0,&ch,sizeof(ch)) == sizeof(ch)) {
        if (ch=='\n') {
            wrapped_write(1,&ch,sizeof(ch));
            i=1;
            continue;
        }
        if (start<=i && i<=end) {
           wrapped_write(1,&ch,sizeof(ch));
        }
        i++;
    }
}

void dOption(char delim, int start, int end) {
    int colCounter=1;
    char ch;
    while(wrapped_read(0,&ch,sizeof(ch)) == sizeof(ch)) {
        if (ch=='\n') {
            wrapped_write(1,&ch,sizeof(ch));
            colCounter=1;
            continue;
        }
        if (ch == delim) {
            colCounter++;
            continue;
        }
        if (colCounter>=start && colCounter<=end) {
            wrapped_write(1,&ch,sizeof(ch));
        }
    }
}

long convertToInt(char str) {
    char * res;
    long num = strtol(&str,&res,10);
    return num;
}

int main(int argc, char* argv[]) {
    if (strcmp(argv[1],"-c")==0) {
        ìf (argc!=3) {
            errx(5,"Invalid arguments count");
        }
        int len = strlen(argv[2]);
        if (len!=1 && len!=3) {
            errx(4,"Invalid arguments options lenght");
        }
        int from = convertToInt(argv[2][0]);
        int end = from;
        if (len == 3) {
            end = convertToInt(argv[2][2]);
        }
        cOption(from,end);
    }
    else if (strcmp(argv[1],"-d")==0) {
        if (argc!=5) {
            errx(6,"Invalid arguments count");
        }
        char delim = argv[2][0];
        if (strcmp(argv[3],"-f")==0) {
            int len = strlen(argv[4]);
            if (len !=1 && len != 3) {
                errx(9,"Invalid argument options count");
            }
            int from = convertToInt(argv[4][0]);
            int end = from;
            if (len==3) {
                end = convertToInt(argv[4][2]);
            }
            dOption(delim,from,end);
        }
        else {
            errx(8,"Invalid third argument");
        }
    }
    else {
        errx(7,"Invalid first argument");
    }
}
