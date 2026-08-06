#include <err.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>
#include <fcntl.h>
#include <sys/stat.h>

int wrapped_read(int fd, void* buff, int size) {
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

off_t wrapped_lseek(int fd, off_t offset, int whence) {
    int l = lseek(fd,offset,whence);
    if (l<0) {
        err(3,"Error seeking");
    }
    return l;
}

size_t getFileSize(int fd) {
    struct stat info;
    if (fstat(fd,&info)==-1) {
        err(4,"Error stating");
    }
    return info.st_size;
}

void mySort(int src, int dest) {
    size_t size1 = getFileSize(src)/sizeof(uint16_t);
    uint16_t ch1;
    uint16_t ch2;
    bool visited[65536] = {false};
    for (size_t i=0;i<size1;i++) {
        size_t minIndex=i;
        wrapper_lseek(src,0,SEEK_SET);
        wrapper_read(src,&ch1,sizeof(ch1));
        for (size_t j=1;j<size1;j++) {
            wrapper_read(src,&ch2,sizeof(ch2));
            if (visited[j] == true) {
                continue;
            }
            if (ch2<ch1) {
                minIndex=j;
                ch1=ch2;
            }
        }
        visited[minIndex]=true;
        wrapped_write(dest,&ch1,sizeof(ch1));
    }
}

int main(int argc, char* argv[]) {
    if (argc!=3) {
        errx(2,"Incorrect argument count");
    }
    int fd1 = open(argv[1],O_RDONLY);
    if (fd1<0) {
        err(3,"Error opening the first file");
    }
    int fd2 = open(argv[2],O_WRONLY | O_CREAT | O_TRUNC, 0666);
    if (fd2<0) {
        err(4,"Error opening the second file");
    }
    mySort(fd1,fd2);
    close(fd1);
    close(fd2);
}
