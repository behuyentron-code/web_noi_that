/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Admin
 */
public class products {
    private int product_id;
    private String product_name;
    private double price;
    private String description;
    private String image;
    private int category_id;
    private String categoryName; 

    private int discount_price; 
    private long quantity;


    
    public products() {
    }

    public products(int product_id, String product_name, double price, String description, String image, int category_id, String categoryName) {
        this.product_id = product_id;
        this.product_name = product_name;
        this.price = price;
        this.description = description;
        this.image = image;
        this.category_id = category_id;
        this.categoryName = categoryName;
    }

    public products(int product_id, String product_name, double price, String description, String image, int category_id, String categoryName, int discount_price, long quantity) {
        this.product_id = product_id;
        this.product_name = product_name;
        this.price = price;
        this.description = description;
        this.image = image;
        this.category_id = category_id;
        this.categoryName = categoryName;
        this.discount_price = discount_price;
        this.quantity = quantity;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getDiscount_price() {
        return discount_price;
    }

    public void setDiscount_price(int discount_price) {
        this.discount_price = discount_price;
    }

    public long getQuantity() {
        return quantity;
    }

    public void setQuantity(long quantity) {
        this.quantity = quantity;
    }
    

}

