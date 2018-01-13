package org.usfirst.frc.team449.robot.subsystem.interfaces.Position;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.usfirst.frc.team449.robot.jacksonWrappers.FPSTalon;
import org.usfirst.frc.team449.robot.jacksonWrappers.YamlSubsystem;

/**
 * Simple Position Subsystem
 */
@JsonIdentityInfo(generator = ObjectIdGenerators.StringIdGenerator.class)
public class SimpleSubsystemPosition extends YamlSubsystem implements SubsystemPosition{

    /**
     * Motor that controls the elevator
     */
    @NotNull
    private FPSTalon motor;

    /**
     * Forward Limit Switch
     */
    @NotNull
    DigitalInput forwardLimitSwitch;

    /**
     * Reverse Limit Switch
     */
    @NotNull
    DigitalInput reverseLimitSwitch;


    /**
     * Default Constructor
     * @param motor The motor changing the position
     * @param forwardLimitSwitch The forward limit switch
     * @param reverseLimitSwitch The reverse limit switch
     */
    public SimpleSubsystemPosition(@NotNull @JsonProperty(required = true) FPSTalon motor,
                                   @NotNull @JsonProperty(required = true) DigitalInput forwardLimitSwitch,
                                   @NotNull @JsonProperty(required = true) DigitalInput reverseLimitSwitch){
        this.motor = motor;
        this.forwardLimitSwitch = forwardLimitSwitch;
        this.reverseLimitSwitch = reverseLimitSwitch;


    }

    /**
     * @param value the position to set the motor to
     */
    public void setPosition(double value){
       motor.setPositionSetpoint(value);

    }

    /**
     * @param value the velocity to set the motor to
     */
    public void setMotorOutput(double value){
        motor.setVelocity(value);
    }

    /**
     * @return the state of the reverse limit switch
     */
    public boolean getReverseLimit(){
        return reverseLimitSwitch.get();
    }

    /**
     * @return the state of the forward limit switch
     */
    public boolean getForwardLimit(){
        return forwardLimitSwitch.get();

    }

    /**
     * Enables the motor
     */
    public void enableMotor(){
        motor.enable();
    }

    /**
     * Disables the motor
     */
    public void disableMotor(){
        motor.disable();
    }
}