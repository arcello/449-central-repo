package org.usfirst.frc.team449.robot.lights;

import edu.wpi.first.wpilibj.I2C;
/**
 * Created by Allison on 1/27/2017.
 */
public class roborioCodeSnippets {

    int portNumber = 168;
    static I2C wire = new I2C(I2C.Port.kOnboard, portNumber);

    if (Global.driver.Buttons.Back.changedDown) {
        String WriteString = "go";
        char[] CharArray = WriteString.toCharArray();
        byte[] WriteData = new byte[CharArray.length];
        for (int i = 0; i < CharArray.length; i++) {
            WriteData[i] = (byte) CharArray[i];
        }
        wire.transaction(WriteData, WriteData.length, null, 0);
    }



}
