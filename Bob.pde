class Ball {
    PVector location;
    float angle, aVel, aAcc; 
    float mass;
    float Bobr;

    Ball(float mass) {
        location = new PVector();
        angle = PI/4;
        aVel = 0.0;
        aAcc = 0.0;
        Bobr = 12;
        this.mass = mass;
    }

    void update(float calcaAcc, PVector origin, float len) {
        aAcc = calcaAcc; //Hornhröðunin er sú sem fundin var með Runge-Kutta aðferðinni.
        aVel += aAcc;    //Hornhraðinn er uppfærður eftir hornhröðuninni.
        angle += aVel;   //Hornið er uppfært eftir hornhraðanum.

        // Origin er upphafspunktur sem við vinnum útfrá.
        // Þannig er Origin upphafspunktur fyrsta pendúlsins,
        // en kúlan á fyrri pendúlnum er upphafspunktur pendúls númer 2.
        location.set(origin.copy());
        location.add(len * sin(angle), len * cos(angle), 0);
    }
    
    void display() {
        ellipse(location.x, location.y, Bobr, Bobr);
    }
}