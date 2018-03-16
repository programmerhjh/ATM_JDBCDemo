package com.demo.atm.bean;

/**
 * @author 洪家豪
 *         Created by acer on 2018/3/15.
 */
public class BankAcount {

    private long userId;

    private long bankAcountId;

    private double balance;

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getBankAcountId() {
        return bankAcountId;
    }

    public void setBankAcountId(long bankAcountId) {
        this.bankAcountId = bankAcountId;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }
}
