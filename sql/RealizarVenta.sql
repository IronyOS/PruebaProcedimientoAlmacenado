DELIMITER //

CREATE PROCEDURE RealizarVenta(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_cliente INT;

    START TRANSACTION;

    -- Validar cantidad
    IF p_cantidad <= 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '❌ La cantidad debe ser mayor que cero';
    END IF;

    -- Validar cliente
    SELECT id_cliente INTO v_cliente
    FROM Clientes
    WHERE id_cliente = p_id_cliente;

    IF v_cliente IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '❌ El cliente no existe';
    END IF;

    -- Validar producto y stock
    SELECT cantidad INTO v_stock
    FROM Productos
    WHERE id_producto = p_id_producto;

    IF v_stock IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '❌ El producto no existe';
    END IF;

    IF v_stock < p_cantidad THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '❌ Stock insuficiente para realizar la venta';
    END IF;

    -- Obtener precio y calcular total
    SELECT precio_venta INTO v_precio
    FROM Productos
    WHERE id_producto = p_id_producto;

    SET v_total = v_precio * p_cantidad;

    -- Insertar factura
    INSERT INTO Facturas (
        fecha_factura, id_cliente, id_producto,
        cantidad, precio_unitario, total
    ) VALUES (
        CURDATE(), p_id_cliente, p_id_producto,
        p_cantidad, v_precio, v_total
    );

    -- Actualizar inventario
    UPDATE Productos
    SET cantidad = cantidad - p_cantidad
    WHERE id_producto = p_id_producto;

    COMMIT;
END;
//

DELIMITER ;
