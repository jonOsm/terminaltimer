#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int duration=3; //globals are probably a very bad idea in c (always?)

enum Selection {
    EXIT,
    START_TIMER,
    MODIFY_TIMER,
    TOGGLE_AUDIO
};

void display_menu() {
    printf("\n\n");
    printf("============= Terminal Timer ===============\n");
    printf("Menu:\n");
    printf("%d - Start Timer\n", START_TIMER);
    printf("%d - Modify Timer\n", MODIFY_TIMER);
    printf("%d - Toggle Audio\n", TOGGLE_AUDIO);
    printf("%d - Exit\n", EXIT);
}

void start_timer(int duration) {
    
    for (int remaining=duration; remaining >= 0; remaining--) {
        int hours = remaining/3600;
        int minutes = (remaining%3600)/60;
        int seconds = (remaining%3600)%60;
        //abstract into own function
        printf("\r\033[1A\033[0K%d:%02d:%02d\n", hours, minutes, seconds);
        sleep(1);
    }
    printf("Timer complete.\n");
}

int main() {

    while(1) {
        int selection = -1; //is there null in C? is null a bad practice (seg fault?)
        display_menu();
        printf("Enter selection: ");
        //TODO: handle invalid input (research this!)
        scanf("%d", &selection); //heres where stuff gets wild. try entering a string here! you can't explain that.

        switch (selection) {
        case START_TIMER:
            /* code */
            start_timer(duration);
            break;
        case MODIFY_TIMER:
            printf("implement modify timer");
            break;
        case TOGGLE_AUDIO:
            printf("implement audio toggle");
            break;
        case EXIT:
            printf("Goodbye.\n");
            printf("=============================");
            exit(0);
        default:
            break;
        }
    }

    
    display_menu();

    return 0;
}