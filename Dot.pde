class Dot {

    // member variables
    float x, y, z;
    float x_spd, y_spd, z_spd;
    float speed;
    float ch, r, t;
    float theta;
    float range;
    float rand;
    int c;

    // constructor
    Dot(float range, float speed, int c) {
        
        // assign values
        this.range = range;
        this.speed = speed;
        this.c = c;

        // set initial values
        theta = random(TWO_PI);
        rand = random(range);
        x = rand * cos(theta);
        y = rand * sin(theta);
        z = (range/2)*cos(theta);

        int val1 = setRandValue();
        int val2 = setRandValue();
        int val3 = setRandValue();

        x_spd = val1 * random(speed/5, speed);
        y_spd = val2 * random(speed/5, speed);
        z_spd = val3 * random(speed/5, speed);

        t = random(TWO_PI);
        r = random(1, 15);
    }

    // displays the dot object
    void display(color c, float trans) {
        float rand = random(1,20);
        for (int i = 0; i < 5;i++) {
            strokeWeight(rand-i);
            stroke(c, trans);
            point(x, y);
        }
    }

    // moves the dot object
    void move() {
        x += x_spd;
        y += y_spd;
        z += z_spd;
        t += 0.05;

        if (mag(x, y, z) > range) {
            x_spd *= -1;      
            y_spd *= -1;
            z_spd *= -1;
        }
    }
    
    // a mutator that changes speed
    void setSpeed(float speed){
        if (x_spd < 0){
            x_spd = -speed;
            
        }
        else{
            x_spd = speed;
        }
       
        if (y_spd < 0){
            y_spd = -speed;
            
        }
        else{
            y_spd = speed;
        }
        
               
    }

    // set random value
    private int setRandValue(){
        float val = random(1);
        if (val > 0.5) {
            return 1;
        }
        return -1;
        
    }
    
   
}
