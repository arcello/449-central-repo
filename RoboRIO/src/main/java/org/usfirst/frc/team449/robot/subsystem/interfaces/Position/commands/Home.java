package org.usfirst.frc.team449.robot.subsystem.interfaces.Position.commands;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import org.jetbrains.annotations.NotNull;
import org.usfirst.frc.team449.robot.jacksonWrappers.YamlCommandWrapper;
import org.usfirst.frc.team449.robot.subsystem.interfaces.Position.SubsystemPosition;

@JsonIdentityInfo(generator = ObjectIdGenerators.StringIdGenerator.class)
public class Home extends YamlCommandWrapper {

	/**
	 * The subsystem to execute this command on.
	 */
	@NotNull
	private final SubsystemPosition subsystem;

	/**
	 * Default constructor
	 *
	 * @param subsystem The subsystem to execute this command on.
	 */
	public Home(@NotNull@JsonProperty(required = true) SubsystemPosition subsystem){
		this.subsystem = subsystem;
	}

	@Override
	protected boolean isFinished() {
		return false;
	}
}