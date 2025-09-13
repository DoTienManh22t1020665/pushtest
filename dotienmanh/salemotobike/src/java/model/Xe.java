
package model;

public class Xe {
   private int id;
   private String tenxe;
   private int idmau;
   private Double giaban;
   private String img;
   private String img1;
   private String img2;
   private String img3;
   private String img4;
   private String tinhnang;
   private String thietke;
   private String dongco;
   private String tienichantoan;
   private int loaixe;
   private boolean xemoi;

    public Xe(int id, String tenxe, int idmau, Double giaban, String img, String img1, String img2, String img3, String img4, String tinhnang, String thietke, String dongco, String tienichantoan, int loaixe, boolean xemoi) {
        this.id = id;
        this.tenxe = tenxe;
        this.idmau = idmau;
        this.giaban = giaban;
        this.img = img;
        this.img1 = img1;
        this.img2 = img2;
        this.img3 = img3;
        this.img4 = img4;
        this.tinhnang = tinhnang;
        this.thietke = thietke;
        this.dongco = dongco;
        this.tienichantoan = tienichantoan;
        this.loaixe = loaixe;
        this.xemoi = xemoi;
    }

    public int getId() {
        return id;
    }

    public String getTenxe() {
        return tenxe;
    }

    public int getIdmau() {
        return idmau;
    }

    public Double getGiaban() {
        return giaban;
    }

    public String getImg() {
        return img;
    }

    public String getImg1() {
        return img1;
    }

    public String getImg2() {
        return img2;
    }

    public String getImg3() {
        return img3;
    }

    public String getImg4() {
        return img4;
    }

    public String getTinhnang() {
        return tinhnang;
    }

    public String getThietke() {
        return thietke;
    }

    public String getDongco() {
        return dongco;
    }

    public String getTienichantoan() {
        return tienichantoan;
    }

    public int getLoaixe() {
        return loaixe;
    }

    public boolean isXemoi() {
        return xemoi;
    }

  public void setId(int id) { this.id = id; }
    public void setTenxe(String tenxe) { this.tenxe = tenxe; }

    public void setIdmau(int idmau) { this.idmau = idmau; }
    public void setGiaban(Double giaban) { this.giaban = giaban; }
    public void setImg(String img) { this.img = img; }
    public void setImg1(String img1) { this.img1 = img1; }
    public void setImg2(String img2) { this.img2 = img2; }
    public void setImg3(String img3) { this.img3 = img3; }
    public void setImg4(String img4) { this.img4 = img4; }
    public void setTinhnang(String tinhnang) { this.tinhnang = tinhnang; }
    public void setThietke(String thietke) { this.thietke = thietke; }
    public void setDongco(String dongco) { this.dongco = dongco; }
    public void setTienichantoan(String tienichantoan) { this.tienichantoan = tienichantoan; }
    public void setLoaixe(int loaixe) { this.loaixe = loaixe; }
    public void setXemoi(boolean xemoi) { this.xemoi = xemoi; }
   public Xe() {}
}
