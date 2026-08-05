#include <err.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

typedef struct {
    uint16_t offset;
    uint8_t length;
    uint8_t notUsed;
} block;

int wrapper_read(int fd, void* buff, int size) {
    int r = read(fd,buff,size);
    if(r<0) {
        err(4,"Error reading");
    }
    return r;
}

int wrapper_write(int fd, const void* buff, int size) {
    int w = write(fd,buff,size);
    if(w<0) {
        err(3,"Error writing");
    }
    return w;
}

off_t wrapper_lseek(int fd, off_t offset, int whence) {
    off_t l = lseek(fd,offset,whence);
    if(l<0) {
        err(2,"Error seeking %d", fd);
    }
    return l;
}

int getFileSize(int fd) {
    struct stat info;
    if(fstat(fd,&info)<0) {
        err(10,"Error on stat");
    }
    return info.st_size;
}

int main(int argc, char* argv[]) {
    if (argc != 5) {
        errx(1,"Incorrect count parameters");
    }
    int fd1 = open(argv[1],O_RDONLY);
    if (fd1<0) {
        err(5,"Error opening the first file");
    }
    int fd2 = open(argv[2],O_RDONLY);
    if(fd2<0) {
        err(6,"Erro opening the second file");
    }
    int fd3 = open(argv[3],O_WRONLY | O_CREAT | O_TRUNC,0666);
    if(fd3 < 0) {
        err(7,"Error opening %s", argv[3]);
    }
    int fd4 = open(argv[4],O_WRONLY | O_CREAT | O_TRUNC,0666);
    if(fd4<0) {
        err(8,"Error opening %s", argv[4]);
    }
    block b1;
    block b2;
    if(getFileSize(fd2) % sizeof(b1) !=0 ) {
        errx(11,"Second file is not in correct format");
    }
    while(wrapper_read(fd2,&b1,sizeof(b1)) == sizeof(b1)) {
        printf("Offset: %d , Length: %d , FileSize: %d\n", b1.offset, b1.leg
        if (b1.offset + b1.length > getFileSize(fd1)) {
            continue;
        }
        wrapper_lseek(fd1,b1.offset,SEEK_SET);
        char str[257];
        int length = wrapper_read(fd1,str,b1.length);
        if(str[0] >= 'A' && str[0] <= 'Z') {
            int currPos = wrapper_lseek(fd3,0,SEEK_CUR);
            b2.offset = currPos;
            b2.length = length;
            wrapper_write(fd3,str,length);
            wrapper_write(fd4,&b2,sizeof(b2));
        }
    }
    close(fd1);
    close(fd2);
    close(fd3);
    close(fd4);
}
