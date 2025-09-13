/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class User {
    private int id;
    private String username;
    private String email;
    private String fullname;
    private String password;
    private String phone;
    private String role;
    private String address;

    public User(int id, String username, String email, String fullname, String password, String phone, String role, String address) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.fullname = fullname;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.address = address;
    }

    public int getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getFullname() {
        return fullname;
    }

    public String getPassword() {
        return password;
    }

    public String getPhone() {
        return phone;
    }

    public String getRole() {
        return role;
    }

    public String getAddress() {
        return address;
    }
    
}
