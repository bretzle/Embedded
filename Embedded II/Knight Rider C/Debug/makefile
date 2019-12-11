################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Startup/subdir.mk
-include Src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
Knight\ Rider\ C.elf \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
Knight\ Rider\ C.list \


# All Target
all: Knight\ Rider\ C.elf secondary-outputs

# Tool invocations
Knight\ Rider\ C.elf: $(OBJS) $(USER_OBJS) C:\Users\bretzj\Desktop\embedded\Embedded\ II\Knight\ Rider\ C\STM32F446RETX_FLASH.ld
	arm-none-eabi-gcc -o "Knight Rider C.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m4 -T"C:\Users\bretzj\Desktop\embedded\Embedded II\Knight Rider C\STM32F446RETX_FLASH.ld" --specs=nosys.specs -Wl,-Map="Knight Rider C.map" -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb -u _printf_float -u _scanf_float -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

Knight\ Rider\ C.list: $(EXECUTABLES)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "Knight Rider C.list"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) *
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
