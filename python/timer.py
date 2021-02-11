from time import sleep
import datetime

#better to use Class(Enum) here?
EXIT = 0
START_TIMER = 1
MODIFY_TIMER = 2
TOGGLE_AUDIO = 3

duration = 3 #in seconds

def start_timer(duration):
    print("")
    for remaining in range(duration, 0, -1):
        formated_duration = str(datetime.timedelta(seconds=remaining))
        # print(f"\r\033[1A\033[0K{i}") #cursor jumps every second and some characters aren't handled by cmd prompt
        print(f"\r{formated_duration} ", flush=True, end='') #flush to have clean input once timer is done. cursor is still ugly - can we hide it?
        sleep(1)
    print("\nTimer Complete.")

def display_menu():
    print("")
    print("============= Terminal Timer ===============")
    print("Menu:")
    print("1 - Start Timer")
    print("2 - Modify Timer")
    print("3 - Toggle Audio")
    print("0 - Exit")

def get_menu_selection():
    selection = None
    try:
        selection = int(input("Enter Selection: "))
        # may want helper function to find max num in Selection Enum
        if selection < EXIT or selection > TOGGLE_AUDIO: raise Exception
    except:
        selection = -1
    return selection


if __name__ == "__main__":
    while 1:
        display_menu()
        selection = get_menu_selection()
        if selection == 1:
            start_timer(duration)
        elif selection == 2:
            print("IMPLEMENT MODIFY TIMER")
        elif selection == 3:
            print ("IMPLEMENT TOGGLE AUDIO")
        elif selection == -1:
            print ("Invalid Input.")
        elif selection == 0:
            print ("Goodbye.")
            print ("======================================")
            quit()
   