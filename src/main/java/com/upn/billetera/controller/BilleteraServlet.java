package com.upn.billetera.controller;

import com.upn.billetera.model.Movimiento;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BilleteraServlet", urlPatterns = {"/billetera"})
public class BilleteraServlet extends HttpServlet {

    private static final double SALDO_INICIAL = 250.00;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        inicializarSesion(session);

        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            request.setAttribute("gastoSolicitado", session.getAttribute("gastoSolicitado"));
            session.removeAttribute("error");
            session.removeAttribute("gastoSolicitado");
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        inicializarSesion(session);

        double saldo = (double) session.getAttribute("saldo");
        @SuppressWarnings("unchecked")
        List<Movimiento> movimientos = (List<Movimiento>) session.getAttribute("movimientos");

        String tipo = request.getParameter("tipo");
        String montoStr = request.getParameter("monto");

        if (tipo == null || (!tipo.equals("Recarga") && !tipo.equals("Gasto"))) {
            session.setAttribute("error", "Seleccione un tipo de movimiento válido.");
            response.sendRedirect(request.getContextPath() + "/billetera");
            return;
        }

        double monto;
        try {
            if (montoStr == null || montoStr.trim().isEmpty()) {
                throw new NumberFormatException();
            }
            monto = Double.parseDouble(montoStr);
            if (monto <= 0) {
                session.setAttribute("error", "El monto debe ser mayor a S/ 0.00.");
                response.sendRedirect(request.getContextPath() + "/billetera");
                return;
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Ingrese un monto numérico válido.");
            response.sendRedirect(request.getContextPath() + "/billetera");
            return;
        }

        if (tipo.equals("Gasto") && monto > saldo) {
            session.setAttribute("gastoSolicitado", monto);
            session.setAttribute("error", "Saldo insuficiente");
            response.sendRedirect(request.getContextPath() + "/billetera");
            return;
        }

        if (tipo.equals("Recarga")) {
            saldo += monto;
        } else {
            saldo -= monto;
        }

        movimientos.add(0, new Movimiento(tipo, monto));
        session.setAttribute("saldo", saldo);
        session.setAttribute("movimientos", movimientos);

        response.sendRedirect(request.getContextPath() + "/billetera");
    }

    private void inicializarSesion(HttpSession session) {
        if (session.getAttribute("saldo") == null) {
            session.setAttribute("saldo", SALDO_INICIAL);
        }
        if (session.getAttribute("movimientos") == null) {
            session.setAttribute("movimientos", new ArrayList<Movimiento>());
        }
    }
}
