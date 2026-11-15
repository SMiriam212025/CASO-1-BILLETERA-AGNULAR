package com.upn.billetera.model;

import java.io.Serializable;

public class Movimiento implements Serializable {
    private String tipoM;
    private double monto;

    public Movimiento(String tipoM, double monto) {
        this.tipoM = tipoM;
        this.monto = monto;
    }

    public String 0getTipo() { return tipoM; }
    public double getMonto() { return monto; }
}
