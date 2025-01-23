-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS webasir;

-- Usar la base de datos creada
USE webasir;

-- Crear la tabla de clientes
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(100),
    descripcion VARCHAR(255),
    email VARCHAR(100),
    telefono VARCHAR(15)
);

-- Insertar 10 registros de clientes con datos aleatorios
INSERT INTO clientes (razon_social, descripcion, email, telefono) VALUES
    ('ByteTech Solutions', 'Proveedor de servicios de TI', 'info@bytetechsolutions.com', '123-456-7890'),
    ('CyberNet Innovations', 'Desarrollo de software especializado', 'info@cybernetinnovations.com', '456-789-0123'),
    ('DataForge Systems', 'Sistemas de gestión de datos', 'info@dataforge.com', '789-012-3456'),
    ('EagleEye Technologies', 'Soluciones de seguridad cibernética', 'info@eagleeyetech.com', '012-345-6789'),
    ('FusionSoft Solutions', 'Desarrollo web y móvil', 'info@fusionsolutions.com', '345-678-9012'),
    ('GeekGenius Enterprises', 'Soporte técnico y consultoría', 'info@geekgenius.com', '678-901-2345'),
    ('InnovaCode Labs', 'Innovación en desarrollo de software', 'info@innovacode.com', '901-234-5678'),
    ('NexTech Systems', 'Tecnologías emergentes y soluciones', 'info@nextechsys.com', '234-567-8901'),
    ('QuantumTech Solutions', 'Sistemas informáticos cuánticos', 'info@quantumtech.com', '567-890-1234'),
    ('TechSavvy Solutions', 'Servicios de consultoría en TI', 'info@techsavvy.com', '890-123-4567');