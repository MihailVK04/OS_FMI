#include <err.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>
#include <fcntl.h>
#include <sys/stat.h>

int wrapper_read(int fd, void* buff, int size) {
    int r = read(fd,buff,size);
    if (r<0) {
        err(1,"Error reading");
    }
    return r;
}

int wrapper_write(int fd, const void* buff, int size) {
    int w = write(fd,buff,size);
    if (w<0) {
        err(2,"Error writing");
    }
    return w;
}

int getFileSize(int fd) {
    struct stat info;
    if (fstat(fd,&info) == -1) {
        err(4,"Error with stat");
    }
    return info.st_size;
}

off_t wrapper_lseek(int fd, off_t offset, int whence) {
    int r = lseek(fd,offset,whence);
    if (r<0) {
        err(3,"Error with seek");
    }
    return r;
}

void selectionSort(int src) {
    int size1 = getFileSize(src)/sizeof(uint32_t);
    uint32_t ch1;
    uint32_t ch2;
    for (int i=0; i<size-1; i++) {
        size_t iNumber = i*sizeof(uint32_t);
        size_t minIndex = iNumber;
        wrapper_lseek(src,iNumber,SEEK_SET);
        wrapper_read(src,&ch1,sizeof(ch1));
        for (int j=i+1;j<size;j++) {
            wrapper_read(src,&ch2,sizeof(ch2));
            if (ch2<ch1) {
                minIndex = j*sizeof(uint32_t);
                ch1=ch2;
            }
        }
        if (minIndex!=iNumber) {
            wrapper_lseek(src,iNumber,SEEK_SET);
            uint32_t curr;
            wrapper_read(src,&curr,sizeof(curr));
            wrapper_lseek(src,minIndex,SEEK_SET);
            wrapper_write(src,&curr,sizeof(curr));
            wrapper_lseek(src,iNumber,SEEK_SET);
            wrapper_write(src,&ch1,sizeof(ch1));
        }
    }
}

void copyFile(int fd1, int fd2) {
    uint32_t ch;
    while (wrapper_read(fd1,&ch,sizeof(ch)) == sizeof(ch)) {
        wrapper_write(fd2,&ch,sizeof(ch));
    }
}

int main(int argc, char* argv[]) {
    if (argc!=3) {
        errx(2,"Incorrect arguments count");
    }
    int fd1 = open(argv[1],O_RDONLY);
    if (fd1<0) {
        err(3,"Error opening the first file");
    }
    int fd2 = open(argv[2], O_RDWR | O_CREAT | O_TRUNC, 0666);
    if (fd2<0) {
        err(4,"Error opening the second file");
    }
    copyFile(fd1,fd2);
    selectionSort(fd2)
    close(fd1);
    close(fd2);
}
