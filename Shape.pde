class Shape { //<>//

    // member variables
    PVector v1;
    final float m_diam = 20;
    final float m_z = (width + height) / 4;
    final float SCALE = m_z;
    PVector wpos, spos, vpos; // world pos, screen pos, view pos
    float diam;
    String shape;
    float rotX, rotY, rotZ;
    float sumRotX, sumRotY, sumRotZ;
  
    // constructor
    Shape(String shape) {
        this.shape = shape;
        wpos = new PVector(random(0, width), random(0, height), random(0, m_z));
        vpos = new PVector();
        rotX = random(0, 1);
        rotY = random(0, 1);
        rotZ = random(0, 1);
        
    }

    // updates position according to speed
    void update(float speed) {
        wpos.z -= speed;
        if (wpos.z < 1) {
            wpos.z = width/2;
            wpos.x = random(-width/2, width/2);
            wpos.y = random(-height/2, height/2);
        }
    }

    // display shapes in different form
    void show(color c, float intensity) {
        //if(intensity < 0.05){
        //    fill(0);
        //    stroke(255,20);

        //}
    
        fill(c, intensity*2);
        stroke(c,intensity*2);

        
        //fill(c, intensity*2);

        //stroke(30, 150, 255, 10);
        //stroke(c,intensity*2);
        // noStroke();
        
        diam = map(wpos.z, 0, m_z, m_diam, 0);

        if(shape.equals("ell")){ // ellipse or the shiny dot
            ellipse(spos.x, spos.y, diam+(intensity/10), diam+(intensity/10));
        }
        else if(shape.equals("cube")){ // cube
            pushMatrix();
            translate(spos.x, spos.y, spos.z);

            // rotate
            sumRotX += intensity*(rotX/1000);
            sumRotY += intensity*(rotY/1000);
            sumRotZ += intensity*(rotZ/1000);
            rotateX(sumRotX);
            rotateY(sumRotY);
            rotateZ(sumRotZ);

            box(diam+20);

            popMatrix();
        }
        
    }
    
    // checks edges(out of grid) and reset them
    void checkEdge(){
        if(spos.x <= 0 || spos.x >= width || spos.y <=0 || spos.y >= height){
            wpos.set(random(0, width), random(0, height), m_z); 
        } 
    }
    
    // change moving direction according to mouse pt
    void transform(PVector pt){
        vpos.x = (wpos.x - pt.x) / wpos.z * SCALE;
        vpos.y = (wpos.y - pt.y) / wpos.z * SCALE;
        spos = PVector.add(pt, vpos);
    }
}
