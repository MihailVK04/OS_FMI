#include <err.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>
#include <fcntl.h>
#include <sys/stat.h>

typedef struct Trio {
    uint16_t offset;
    uint8_t original;
    uint8_t new;
} Trio;

int wrapper_read(int fd, void* buff, int size) {
    int r = read(fd,buff,size);
    if (r<0) {
        err(2,"Error reading");
    }
    return r;
}

int wrapper_write(int fd, const void* buff, int size) {
    int w = write(fd,buff,size);
    if (w<0) {
        err(3,"Error writing");
    }
    return w;
}

void vopyFile(int src, int dest) {
    uint8_t ch;
    while(wrapper_read(src,&ch,sizeof(ch)) == sizeof(ch)) {
        wrapper_write(dest,&ch,sizeof(ch));
    }
}

int getFileSize(int fd) {
    struct stat info;
    if (fstat(fd,&info) < 0) {
        err(6,"Error with stat");
    }
    return info.st_size;
}

off_t wrapper_lseek(int fd, off_t offset, int whence) {
    off_t l = lseek(fd,offset,whence);
    if (l<0) {
        err(11,"Error with seek");
    }
    return l;
}

int main(int argc, char* argv[]) {
    if (argc!=4) {
        errx(1,"Not correct arguments count");
    }
    int fd1 = open(argv[2],O_RDONLY);
    if (fd1<0) {
        err(4,"Error opening the first file");
    }
    int fd2 = open(argv[3],O_RDWR | O_CREAT | O_TRUNC,0666);
    if (fd2<0) {
        err(5,"Error opening the second file");
    }
    int patch = open(argv[1],O_RDONLY);
    if (patch<0) {
        err(8,"Error opening the patch file");
    }
    copyFiles(fd1,fd2);

    Trio t;
    if(getFileSize(patch) % sizeof(t) != 0) {
        errx(9,"The patch file is not in correct format");
    }
    while (wrapper_read(patch,&t,sizeof(t)) == sizeof(t)) {
        if(t.offset > getFileSize(fd1)) {
            errx(10,"Invalid offset");
        }
        wrapper_lseek(fd1,t.offset,SEEK_SET);
        wrapper_lseek(fd2,t.offset,SEEK_SET);
        uint8_t byte;
        wrapper_read(fd1,&byte,sizeof(byte));
        if(byte != t.original) {
            errx(11,"Incorrect data in patch");
        }
        wrapper_write(fd2,&t.new,sizeof(t.new));
    }
}
