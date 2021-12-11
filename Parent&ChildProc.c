#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
int main(int argc, char *argv[])
{
    //открываем файл в режиме чтения
    FILE *f = fopen("in.txt", "r");

    pid_t wait(int *status);

    //входные данные, результат, счетчик
    int inpA, inpB, inpC, inpD, inpE, inpF, inpH, inpK, inpM, result, count, status, mainId, ParentId;
    count = 0;
    mainId = getpid();
    //считаем кол-во строк в файле
    while (!feof(f))
    {
        fscanf(f, "%*[^\n]%*c)");
        count++;
    }
    fclose(f);

    //повторно открываем файл
    FILE *file = fopen("in.txt", "r");
    pid_t pid;

    for (int i = 0; i < count; i++)
    {
        pid = fork();
        //дочерний процесс

        if (pid == 0 && getpid() != mainId)
        {
            //построчное считывание из файла
            fscanf(file, "%d %d %d %d %d %d %d %d %d", &inpA, &inpB, &inpC, &inpD, &inpE, &inpF, &inpH, &inpK, &inpM);
            //расчет значения+ вывод на экран
            result = inpA * inpB / (inpC + inpD) + (inpE + inpF) / inpH + inpK * inpM;
            printf("PID: %d", getpid());
            printf("  Result:  %d * %d / (%d + %d) + (%d + %d) / %d + %d * %d ---> %d\n", .inpA, inpB, inpC, inpD, inpE, inpF, inpH, inpK, inpM, result);
        }

        else
        {
            //родительский процесс
            pid = wait(&status);
            printf("BatyaPID: %d\n", getpid());
            fclose(file);
            return 0;
        }
    }
}
//мое уравнение ВАРИАНТ 19 ---> (a*b)/(c+d)+(e+f)/h+k*m