package org.usfirst.frc.team449.robot.subsystem.interfaces.position;

import com.fasterxml.jackson.annotation.JsonTypeInfo;

/**
 * A subsystem that is a position-controller for device that moves between two limits, such as an elevator, or a turret.
 */
@JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, include = JsonTypeInfo.As.WRAPPER_OBJECT)
public interface SubsystemPosition {

	/**
	 * Gets device position value.
	 *
	 * @return Device position value
	 * */
	void getPosition(int value);

	/** Sets device position to input value. */
	void setPosition(int value);

	/**
	 * Gets the motor output.
	 *
	 * @return Motor output value
	 * */
	void getMotorOutput(int value);

	/** Sets the motor output to a value. */
	void setMotorOutput(int value);

	/**
	 * Gets the state of the reverse limit switch.
	 *
	 * @return true if reverse limit is switched on, else false
	 * */
	boolean getReverseLimit();

	/** Sets the state of the reverse limit switch. */
	void setReverseLimit();

	/**
	 * Gets the state of the forward limit switch.
	 *
	 * @return true if forward limit is switched on, else false
	 * */
	boolean getForwardLimit();

	/** Sets the state of the forward limit switch. */
	void setForwardLimit();

	/** Method for enabling the motor. */
	void enableMotor();

	/** Method for disabling the motor. */
	void disableMotor();
}