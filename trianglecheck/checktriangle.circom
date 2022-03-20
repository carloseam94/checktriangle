pragma circom 2.0.0;

include "../circomlib/comparators.circom";

template checkTriangle() {
    signal input energy;
    // coordinate A
    signal input x1;
    signal input y1;
    // coordinate B
    signal input x2;
    signal input y2;
    // coordinate C
    signal input x3;
    signal input y3;
    // output
    signal output out;

    // distance of AB
    signal diffX_ab;
    signal diffY_ab;
    diffX_ab <== x2 - x1;
    diffY_ab <== y2 - y1;
    signal diffXX_ab;
    signal diffYY_ab;
    diffXX_ab <== diffX_ab * diffX_ab;
    diffYY_ab <== diffY_ab * diffY_ab;
    signal ab;
    ab <== diffXX_ab + diffYY_ab;
    
    // distance of BC
    signal diffX_bc;
    signal diffY_bc;
    diffX_bc <== x3 - x2;
    diffY_bc <== y3 - y2;
    signal diffXX_bc;
    signal diffYY_bc;
    diffXX_bc <== diffX_bc * diffX_bc;
    diffYY_bc <== diffY_bc * diffY_bc;
    signal bc;
    bc <== diffXX_bc + diffYY_bc;

    component leqAbEnergy = LessEqThan(64);
    component leqBcEnergy = LessEqThan(64);

    leqAbEnergy.in[0] <== ab;
    leqAbEnergy.in[1] <== energy * energy;

    leqBcEnergy.in[0] <== bc;
    leqBcEnergy.in[1] <== energy * energy;

    // AB and BC distances are lesser than energy, every planet can be reached
    signal energyAB;
    signal energyBC;
    energyAB <== leqAbEnergy.out;
    energyBC <== leqBcEnergy.out;
    energyAB === 1;
    energyBC === 1;

    // if AB slope and BC slope are equals, the three points are aligned: (y2 - y1) / (x2 - x1) = (y3 - y2) / (x3 - x2)
    // to avoid division by zero (y2 - y1) * (x3 - x2) = (y3 - y2) * (x2 - x1)
    signal num1den2;
    num1den2 <== (y2 - y1) * (x3 - x2);
    signal den1num2;
    den1num2 <== (y3 - y2) * (x2 - x1);

    component ie = IsEqual();
    ie.in[0] <== num1den2;
    ie.in[1] <== den1num2;

    // Is a valid triangle
    signal isTriangle;
    isTriangle <== 1 - ie.out;
    isTriangle === 1;

    signal allEnergy;
    allEnergy <== energyAB * energyBC;

    out <== allEnergy * isTriangle;
}


component main{public[energy]} = checkTriangle();