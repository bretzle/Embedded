//! John Bretz
//! CE2820-
//! servo.h
//! API for controlling the servos
//!
//! Each servo is effectivly an 8-bit register. Whose value
//! determines the position of the servo. The servo has 
//! 90° of movement. When the register holds 0-200 the servo will
//! move from 0-90°. If the value is >200 the servo will "turn off"
//! (Allowing free range of motion)

#ifndef SERVO_H_
#define SERVO_H_

#define SERVO_0 0
#define SERVO_1 8

/// moves the servo based of the raw_value
/// 
/// @param servo: Should be `SERVO_0` or `SERVO_1`
/// @param raw_value: value from 0-255. See module documentation
///                   for more info on accepted values.
void move_servo(char servo, char raw_value);

/// moves the servo using degrees instead of a raw_value
///
/// @param servo: should be `SERVO_0` or `SERVO_1`
/// @param degree: the number of degrees to move the servo
void move_servo_degree(char servo, char degree);

/// moves both servos in one call
///
/// same as calling 
/// ```
/// move_servo(SERVO_0, raw_value_0);
/// move_servo(SERVO_1, raw_value_1);
/// ``` 
void move_servos(char raw_value_0, char raw_value_1);

/// moves both servos in one call
///
/// same as calling 
/// ```
/// move_servo(SERVO_0, degree_0);
/// move_servo(SERVO_1, degree_1);
/// ``` 
void move_servos_degree(char degree_0, char degree_1);

#endif /* SERVO_H_ */
