plotProfile <- function(profileName, inverted = FALSE, wheelbaseDiameter, centerToFront, centerToBack, centerToSide, startY = 0, startPos = c(-1,-1,-1,-1,-1,-1), usePosition = TRUE){
  left <- read.csv(paste("../calciferLeft",profileName,"Profile.csv",sep=""), header=FALSE)
  right <- read.csv(paste("../calciferRight",profileName,"Profile.csv",sep=""), header=FALSE)
  startingCenter <- c(startY, centerToBack)
  left$V1[1] <- 0
  left$V2[1] <- 0
  left$V3[1] <- left$V3[2]
  right$V1[1] <- 0
  right$V2[1] <- 0
  right$V3[1] <- right$V3[2]
  #Position,Velocity,Delta t, Elapsed time
  left$V4 <- (0:(length(left$V1)-1))*left$V3[1]
  right$V4 <- (0:(length(right$V1)-1))*right$V3[1]
  #Time, Left X, Left Y, Right X, Right Y, Angle
  out <- array(dim=c(length(left$V1),6))
  if(identical(startPos, c(-1,-1,-1,-1,-1,-1))){
    out[1,]<-c(0, startingCenter[2], (startingCenter[1]+wheelbaseDiameter/2.), startingCenter[2], (startingCenter[1]-wheelbaseDiameter/2.), 0)
  } else {
    out[1,]<-startPos
  }
  
  for(i in 2:length(left$V4)){
    #Get the angle the robot is facing.
    perpendicular <- out[i-1,6]
    print(perpendicular)
    
    #Add the change in time
    out[i,1] <- out[i-1,1]+left$V3[i]
    
    #Figure out linear change for each side using position or velocity
    if (usePosition){
      deltaLeft <- left$V1[i] - left$V1[i-1]
      deltaRight <- right$V1[i] - right$V1[i-1]
    } else {
      deltaLeft <- left$V2[i]*left$V3[i]
      deltaRight <- right$V2[i]*left$V3[i]
    }
    
    # Invert the change if nessecary
    if (inverted){
      deltaLeft <- -deltaLeft
      deltaRight <- -deltaRight
    }
    
    diffTerm <- deltaRight - deltaLeft
    #So in this next part, we figure out the turning center of the robot
    #and the angle it turns around that center. Note that the turning center is
    #often outside of the robot.
    
    #Calculate how much we turn first, because if theta = 0, turning center is infinitely far away and can't be calcualted.
    theta <- diffTerm/wheelbaseDiameter
    
    out[i,6] <- out[i-1,6]+theta
    
    # If theta is 0, we're going straight and need to treat it as a special case.
    if (identical(theta, 0)){
      out[i, 2] <- out[i-1,2]+deltaLeft*cos(perpendicular)
      out[i, 3] <- out[i-1,3]+deltaLeft*sin(perpendicular)
      out[i, 4] <- out[i-1,4]+deltaRight*cos(perpendicular)
      out[i, 5] <- out[i-1,5]+deltaRight*sin(perpendicular)
    } else {
      
      #We do this with sectors, so this is the radius of the turning circle for the
      #left and right sides. They just differ by the diameter of the wheelbase.
      rightR <- (wheelbaseDiameter/2) * (deltaRight + deltaLeft) / diffTerm + wheelbaseDiameter/2
      leftR <- rightR - wheelbaseDiameter
      
      #This is the angle for the vector pointing towards the new position of each
      #wheel.
      #To understand why this formula is correct, overlay isoclese triangles on the sectors
      vectorTheta <- (out[i-1,6]+out[i,6])/2
      
      #The is the length of the vector pointing towards the new position of each
      #wheel divided by the radius of the turning circle.
      vectorDistanceWithoutR <- 2*sin(theta/2)
    
      out[i, 2] <- out[i-1,2]+vectorDistanceWithoutR*leftR*cos(vectorTheta)
      out[i, 3] <- out[i-1,3]+vectorDistanceWithoutR*leftR*sin(vectorTheta)
      out[i, 4] <- out[i-1,4]+vectorDistanceWithoutR*rightR*cos(vectorTheta)
      out[i, 5] <- out[i-1,5]+vectorDistanceWithoutR*rightR*sin(vectorTheta)
    }
  }
  return(out)
}

drawProfile <- function (coords, centerToFront, centerToBack, wheelbaseDiameter, clear=TRUE, linePlot = TRUE){
  
  if (clear){
    if (linePlot){
      plot(coords[,2],coords[,3], type="l", col="Green", ylim=c(-16, 16),xlim = c(0,54), xlab = "X Position (feet)", ylab="Y Position (feet)", asp=1)
    } else {
      plot(coords[,2],coords[,3], col="Green", ylim=c(-16, 16), xlim = c(0,54), xlab = "X Position (feet)", ylab="Y Position (feet)", asp=1)
    }
    field <- read.csv("field.csv")
    #Strings are read as factors by default, so we need to do this to make it read them as strings
    field$col <- as.character(field$col)
    for (i in 1:length(field$x1)){
      lines(c(field$x1[i], field$x2[i]), c(field$y1[i], field$y2[i]), col=field$col[i])
    }
  } else {
    if (linePlot){
      lines(coords[,2],coords[,3],col="Green")
    } else {
      points(coords[,2],coords[,3],col="Green")
    }
  }
  if (linePlot){
    lines(coords[,4],coords[,5],col="Red")
  } else {
    points(coords[,4],coords[,5],col="Red")
  }
}

drawRobot <- function(robotFile, robotPos){
  theta <- atan2(robotPos[5] - robotPos[3], robotPos[4] - robotPos[2])
  perp <- theta + pi/2
  robotCenter <- c((robotPos[2]+robotPos[4])/2.,(robotPos[3]+robotPos[5])/2.)
  robot <- read.csv(robotFile)
  rotMatrix <- matrix(c(cos(perp), -sin(perp), sin(perp), cos(perp)), nrow=2, ncol=2, byrow=TRUE)
  
  point1s <- rotMatrix %*% matrix(c(robot$x1, robot$y1), nrow = 2, ncol = length(robot$x1), byrow = TRUE) 
  point1s <- point1s + c(robotCenter[1], robotCenter[2])
  
  point2s <- rotMatrix %*% matrix(c(robot$x2, robot$y2), nrow = 2, ncol = length(robot$x1), byrow = TRUE) 
  point2s <- point2s + c(robotCenter[1], robotCenter[2])
  
  #Interleave the point1s and point2s so lines() draws them correctly.
  xs <- c(rbind(point1s[1,], point2s[1,]))
  ys <- c(rbind(point1s[2,], point2s[2,]))
  
  lines(x=xs, y=ys, col="Blue")
}

wheelbaseDiameter <- 26./12.
centerToFront <- (27./2.)/12.
centerToBack <- (27./2.+3.25)/12.
centerToSide <- (29./2.+3.25)/12.
#                                                                                                                                                                                         Time, Left X, Left Y, Right X, Right Y
out <- plotProfile(profileName = "RedRight", inverted = FALSE, wheelbaseDiameter = wheelbaseDiameter, centerToFront = centerToFront,centerToBack =  centerToBack,centerToSide = centerToSide, startPos=c(0, 54 - centerToBack, 10.3449-wheelbaseDiameter,54-centerToBack,10.3449, pi), usePosition = TRUE)
drawProfile(coords=out, centerToFront=centerToFront, centerToBack=centerToBack, wheelbaseDiameter = wheelbaseDiameter, clear = TRUE, linePlot = TRUE)
tmp <- out[length(out[,1]),]
drawRobot("robot.csv", tmp)
out2 <- plotProfile(profileName = "RedBackup",inverted = TRUE,wheelbaseDiameter =  wheelbaseDiameter,centerToFront = centerToFront,centerToBack = centerToBack,centerToSide = centerToSide,startPos = tmp)
drawProfile(coords = out2, centerToFront = centerToFront, centerToBack = centerToBack, wheelbaseDiameter = wheelbaseDiameter, clear = FALSE)
tmp2 <- out2[length(out2[,1]),]
drawRobot("robot.csv", out2[length(out2[,1]),])
out3 <- plotProfile(profileName = "RedBoilerToLoading",inverted = FALSE,wheelbaseDiameter =  wheelbaseDiameter,centerToFront = centerToFront,centerToBack = centerToBack,centerToSide = centerToSide,startPos = tmp2)
drawProfile(coords = out3, centerToFront = centerToFront, centerToBack = centerToBack, wheelbaseDiameter = wheelbaseDiameter, clear = FALSE)
drawRobot("robot.csv", out3[length(out3[,1]),])

#out <- plotProfile(profileName = "BlueLeft", inverted = FALSE, wheelbaseDiameter = wheelbaseDiameter, centerToFront = centerToFront,centerToBack =  centerToBack,centerToSide = centerToSide, startY= 10.3449-centerToSide, usePosition = TRUE)
#drawProfile(coords=out, centerToFront=centerToFront, centerToBack=centerToBack, wheelbaseDiameter = wheelbaseDiameter, clear = TRUE, linePlot = TRUE)
#tmp <- out[length(out[,1]),]
#drawRobot("robot.csv", tmp)
#out2 <- plotProfile(profileName = "RedBackup",inverted = TRUE,wheelbaseDiameter =  wheelbaseDiameter,centerToFront = centerToFront,centerToBack = centerToBack,centerToSide = centerToSide,startPos = tmp)
#drawProfile(coords = out2, centerToFront = centerToFront, centerToBack = centerToBack, wheelbaseDiameter = wheelbaseDiameter, clear = FALSE)
#tmp2 <- out2[length(out2[,1]),]
#drawRobot("robot.csv", out2[length(out2[,1]),])
#out3 <- plotProfile(profileName = "BoilerToLoading",inverted = FALSE,wheelbaseDiameter =  wheelbaseDiameter,centerToFront = centerToFront,centerToBack = centerToBack,centerToSide = centerToSide,startPos = tmp2)
#drawProfile(coords = out3, centerToFront = centerToFront, centerToBack = centerToBack, wheelbaseDiameter = wheelbaseDiameter, clear = FALSE)
#drawRobot("robot.csv", out3[length(out3[,1]),])