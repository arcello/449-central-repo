package org.usfirst.frc.team449.robot.components.maps;

import org.usfirst.frc.team449.robot.MapObject;

/**
 * A map for a MotorCluster of variable size.
 */
public class MotorClusterMap extends MapObject {
    /**
     * an array of maps for the motors in this Cluster
     */
    public MotorMap[] motors;
    /**
     * whether the whole cluster should be inverted
     */
    public boolean INVERTED;

    public MotorClusterMap(maps.org.usfirst.frc.team449.robot.components.MotorClusterMap.MotorCluster message) {
        super(message);
        INVERTED = message.getInverted();
        motors = new MotorMap[message.getMotorCount()];
        for (int i = 0; i < motors.length; i++){
            motors[i] = new MotorMap(message.getMotor(i));
        }
    }
}