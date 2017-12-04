//Býður uppá það að sýna slóð eða ekki.
enum DISPLAY_TRAIL {
    TRAIL, NO_TRAIL;
}

//Býður uppá það að sýna allan pendúlinn eða bara massapunktana.
enum DISPLAY_MODE {
    LINE, POINT;
}

class DoublePendulum {
    Ball b1, b2;
    PVector origin;

    float len; //Lengd á stöngunum milli massapunktanna, eða kúlanna.
    float g = 0.4; //Þyngdaraflsfasti. Breyting á þessu hefur mikil áhrif á hreyfinguna.
 
    //Búum til tvöfaldan pendúl með massapunktum b1 og b2.
    DoublePendulum(PVector origin, float len) {
        this.origin = origin.copy();
        this.len = len;

        b1 = new Ball(10);
        b2 = new Ball(2);
    }

    void go() {
        update();
        display();
    }

    void update() {
        b1.update(aAcc1(), origin, len);
        b2.update(aAcc2(), b1.location, len);
    }

    void display() {
        stroke(255);
        smooth();
        fill(255);

        if(dm == DISPLAY_MODE.LINE) {
            line(origin.x, origin.y, b1.location.x, b1.location.y);
            line(b1.location.x, b1.location.y, b2.location.x, b2.location.y);
        }
        
        b1.display();
        b2.display();
    }

    //Reiknar út hornhröðunina fyrir massapunkt b1 með Runge-Kutta aðferðinni.
    float aAcc1() {
        float top = -1*g*(2*b1.mass*b2.mass)*sin(b1.angle) - b2.mass*g*sin(b1.angle-(2*b2.angle)) - 
            2*(sin(b1.angle-b2.angle)*b2.mass*(b2.aVel*b2.aVel*len+b1.aVel*b1.aVel*len*cos(b1.angle-b2.angle)));

        float bot = len*(2*b1.mass+b2.mass-b2.mass*cos(2*b1.angle-2*b2.angle));

        return top / bot;
    }

    //Reiknar út hornhröðunina fyrir massapunkt b2 með Runge-Kutta aðferðinni.
    float aAcc2() {
        float top = 2*sin(b1.angle-b2.angle)*(b1.aVel*b1.aVel*len*(b1.mass+b2.mass)+g*(b1.mass+b2.mass)*cos(b1.angle)+b2.aVel*b2.aVel*len*b2.mass*cos(b1.angle-b2.angle));

        float bot = len*(2*b1.mass+b2.mass-b2.mass*cos(2*b1.angle-2*b2.angle));

        return top / bot;
    }
}

DoublePendulum p;
DISPLAY_TRAIL dt;
DISPLAY_MODE dm;

void setup() {
    dt = DISPLAY_TRAIL.NO_TRAIL;
    dm = DISPLAY_MODE.LINE;
    size(640,640);
    if(dt == DISPLAY_TRAIL.TRAIL)
        background(0); //Bakgrunnurinn bara birtur einu sinni, í upphafi. Þetta þýðir að öll færslan á pendúlnum verður eftir, það myndast einskonar slóð.
    frameRate(60);
    blendMode(ADD);
    p = new DoublePendulum(new PVector(width/2, 75), 130);
}

void draw() {
    if(dt == DISPLAY_TRAIL.NO_TRAIL)
        background(0); //Hérna aftur á móti uppfærist bakgrunnurinn í hvert skipti sem pendúllinn hreyfist. Þá sést engin slóð.
    p.go();
}