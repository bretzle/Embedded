typedef enum {PAUSED, ACTIVE} task_state;

#define SCB_ICSR 0xE000ED04
#define PENDSVET 28

typedef struct {
	int* stack_pointer;
	task_state state;
	int ticks_starting;
	int ticks_remaining;
} task;

void tasker_tick(void);
void init_tasker(int total_tasks, int main_ticks);
void init_task(int task_num, int stack_size, void(*entry_point)(void), int ticks);
void SysTick_Init(void);