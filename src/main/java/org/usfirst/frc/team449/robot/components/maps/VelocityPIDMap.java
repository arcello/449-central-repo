package org.usfirst.frc.team449.robot.components.maps;

/**
 * Created by Blair Robot Project on 12/8/2016.
 */
public abstract class VelocityPIDMap extends PIDMap {
    /**
     * radius of the range of values around zero, that when read from the
     * encoder when setpoint is 0 results in velocity being 0
     */
    public double zeroTolerance;
    /**
     * the maximum delta velocity from the controller
     */
    public double outputRange;
    /**
     * whether this PIDVelocityMotor should be run backwards
     */
    public boolean inverted;
    /**
     * max speed to run these motors at
     */
    public double speed;

    /**
     * the expected input range to the PID loop; kP, kI, and kD are adjusted
     * to be a percentage of the inputRange (kI = i / inputRange)
     */
    public int inputRange;

    /**
     * Period of the PID control loop
     */
    public double controllerPeriod;

    public double rampRate;
    public boolean rampRateEnabled;

    public VelocityPIDMap(maps.org.usfirst.frc.team449.robot.components.VelocityPIDMap.VelocityPID message) {
        super(message.getSuper());
        zeroTolerance = message.getZeroTolerance();
        outputRange = message.getOutputRange();
        inverted = message.getInverted();
        speed = message.getSpeed();
        inputRange = message.getInputRange();
        controllerPeriod = message.getControllerPeriod();
        rampRate = message.getRampRate();
        rampRateEnabled = message.getRampRateEnabled();
    }
}