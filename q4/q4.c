#include <stdio.h>
#include <dlfcn.h>
#include<string.h>
typedef int (*fptr)(int, int);   // you are equating types int and (*fptr)(int, int).
                                 // this means that fptr must be the type of a pointer to a
                                 // function with signature int, int -> int.

int main() {
    while(1){
        char str[51];
        int a,b;
        int x = scanf("%s%d%d",str,&a,&b);
        if(x==EOF || x!=3) break;
        char lib[51] = "./lib";
        strcat(lib,str);
        strcat(lib,".so");
        // printf("%s\n",lib);
    void* handle = dlopen(lib, RTLD_LAZY);
    if (!handle) {
        printf("dlopen error: %s\n", dlerror());
        continue;
    }        
        fptr op = (fptr)dlsym(handle,str);                 // get a pointer to the add function
        int result = op(a, b);
        printf("%d\n", result);
        dlclose(handle);
    }
    return 0;
}