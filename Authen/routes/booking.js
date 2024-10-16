const express = require("express");
const router = express.Router();
const adminController = require('../controllers/adminController');
const authenticateToken = require("../middlewares/auth");
const {
    addRoom,
    bookingRoom,
    getBookings,
    checkRoomStatus,
    approveBooking,
    returnRoom,
    getUsers,
    getUserByID,
    updateUser,
    deleteUser
} = require("../controllers/adminController");

// ตรวจสอบว่าฟังก์ชันที่นำเข้ามาไม่เป็น undefined
console.log(checkRoomStatus); // ควรจะแสดงฟังก์ชันที่นี่

// เส้นทางสำหรับการจัดการการจองห้องประชุม
router.post('/rooms', addRoom);
router.post("/room/booking", bookingRoom);
router.get("/room/bookings", getBookings);
router.get("/room/status", checkRoomStatus); // ตรวจสอบสถานะห้องประชุม
router.post("/room/approve", approveBooking); // อนุมัติการจองห้องประชุม
router.post('/room/returnroom',returnRoom);// เส้นทางสำหรับคืนห้องประชุม

// เส้นทางสำหรับการจัดการผู้ใช้
router.get("/users", getUsers);
router.get("/users/:id", getUserByID); // ดูข้อมูลผู้ใช้ตาม ID
router.put("/users/:id", updateUser); // อัปเดตข้อมูลผู้ใช้
router.delete("/users/:id", deleteUser); // ลบบัญชีผู้ใช้

module.exports = router;
