<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Billetera Digital - JSP + Servlet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7fb; font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; color: #1e293b; }
        .navbar-custom { background-color: #141c2f; padding: 0.9rem 0; }
        .badge-header { background-color: #2c3954; color: #e2e8f0; font-weight: 500; padding: 0.5rem 1.2rem; border-radius: 50px; font-size: 0.85rem; }
        .card-clean { background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 2px 6px rgba(15, 23, 42, 0.03); }
        .card-info-servlet { background-color: #eef4ff; border: 1px solid #cfe0fc; border-radius: 12px; }
        .btn-get-badge { background-color: #135bec; color: #ffffff; font-weight: 600; border-radius: 8px; padding: 0.45rem 1.5rem; border: none; font-size: 0.9rem; }
        .saldo-monto { color: #137333; font-weight: 700; font-size: 2.6rem; line-height: 1.1; }
        .table-custom { border-radius: 12px; overflow: hidden; border: 1px solid #e2e8f0; background: #ffffff; }
        .table-custom thead { background-color: #141c2f; color: #ffffff; }
        .table-custom thead th { font-weight: 600; padding: 0.85rem 1.25rem; border: none; font-size: 0.95rem; }
        .table-custom tbody td { padding: 0.95rem 1.25rem; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .pill-gasto { background-color: #b92b47; color: #ffffff; border-radius: 50px; padding: 0.35rem 1.4rem; font-weight: 600; font-size: 0.85rem; display: inline-block; min-width: 105px; text-align: center; }
        .pill-recarga { background-color: #137333; color: #ffffff; border-radius: 50px; padding: 0.35rem 1.4rem; font-weight: 600; font-size: 0.85rem; display: inline-block; min-width: 105px; text-align: center; }
        .card-validacion { background-color: #fdf2f4; border: 1px solid #f3c6ce; border-radius: 12px; padding: 1.25rem; }
        .alerta-interna { background-color: #f9d8de; color: #b92b47; font-weight: 600; border-radius: 8px; padding: 0.55rem 0.9rem; font-size: 0.9rem; }
        .btn-registrar { background-color: #135bec; border-color: #135bec; font-weight: 600; padding: 0.55rem 1.2rem; border-radius: 8px; }
        .btn-registrar:hover { background-color: #0e47bd; }
    </style>
</head>
<body>

    <nav class="navbar navbar-custom mb-4">
        <div class="container d-flex justify-content-between align-items-center">
            <span class="navbar-brand text-white fw-semibold fs-4 mb-0">Mi Billetera Digital</span>
            <span class="badge-header">JSP + Servlet</span>
        </div>
    </nav>

    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-md-5">
                <div class="card-clean p-4 h-100 d-flex flex-column justify-content-center">
                    <span class="text-uppercase text-secondary fw-semibold small mb-1">SALDO DISPONIBLE</span>
                    <div class="saldo-monto mb-1">
                        S/ <fmt:formatNumber value="${sessionScope.saldo}" pattern="#,##0.00"/>
                    </div>
                    <span class="text-muted small">
                        Después de ${sessionScope.movimientos.size()} movimientos válidos
                    </span>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card-info-servlet p-4 h-100 d-flex flex-column justify-content-center align-items-start">
                    <span class="btn-get-badge mb-3">GET / Servlet</span>
                    <p class="mb-1 fw-medium text-dark">Obtiene el saldo y el historial de la sesión HTTP.</p>
                    <p class="mb-0 text-secondary small">Envía los datos a la vista JSP para mostrarlos.</p>
                </div>
            </div>
        </div>

        <h5 class="fw-bold mb-3">Movimientos recientes</h5>
        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <div class="table-custom">
                    <c:choose>
                        <c:when test="${empty sessionScope.movimientos}">
                            <div class="p-4 text-center text-muted">
                                Aún no hay movimientos registrados.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="table mb-0">
                                <thead>
                                    <tr>
                                        <th>Tipo</th>
                                        <th>Monto (S/)</th>
                                        <th>Orden</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="mov" items="${sessionScope.movimientos}" varStatus="status">
                                        <tr>
                                            <td>
                                                <span class="${mov.tipo == 'Recarga' ? 'pill-recarga' : 'pill-gasto'}">
                                                    ${mov.tipo}
                                                </span>
                                            </td>
                                            <td class="fw-bold ${mov.tipo == 'Recarga' ? 'text-success' : 'text-danger'}">
                                                ${mov.tipo == 'Recarga' ? '+' : '-'} 
                                                <fmt:formatNumber value="${mov.monto}" pattern="#,##0.00"/>
                                            </td>
                                            <td class="text-secondary">
                                                ${status.first ? 'Más reciente' : 'Anterior'}
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="col-lg-4">
                <c:if test="${not empty requestScope.error}">
                    <div class="card-validacion">
                        <h6 class="fw-bold text-danger mb-2">Error de validación</h6>
                        <c:if test="${not empty requestScope.gastoSolicitado}">
                            <p class="small text-dark mb-1">
                                Gasto solicitado: S/ <fmt:formatNumber value="${requestScope.gastoSolicitado}" pattern="#,##0.00"/>
                            </p>
                        </c:if>
                        <p class="small text-dark mb-1">
                            Saldo disponible: S/ <fmt:formatNumber value="${sessionScope.saldo}" pattern="#,##0.00"/>
                        </p>
                        <div class="alerta-interna mt-2">
                            ${requestScope.error}
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="card-clean p-4 mb-5">
            <h6 class="fw-bold mb-3">Nuevo movimiento</h6>
            <form action="${pageContext.request.contextPath}/billetera" method="post" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label for="tipo" class="form-label text-secondary small mb-1">Tipo</label>
                    <select name="tipo" id="tipo" class="form-select" required>
                        <option value="Recarga">Recarga</option>
                        <option value="Gasto">Gasto</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="monto" class="form-label text-secondary small mb-1">Monto (S/)</label>
                    <input type="number" step="0.01" name="monto" id="monto" class="form-control" placeholder="0.00" required>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary btn-registrar w-100">
                        Registrar movimiento
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
