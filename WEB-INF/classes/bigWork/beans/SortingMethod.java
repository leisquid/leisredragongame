package bigWork.beans;

public class SortingMethod {
    /* method == 0, °´Ö÷¼ü reading_id ÅÅĞò¡£
     * method == 1, °´ reading µÄÆ´ÒôÅÅĞò¡£
     * method == 2, °´Î²×ÖÔÏÄ¸ + reading_id ÅÅĞò¡£
     * method == 3, °´Î²×ÖÔÏÄ¸ + reading µÄÆ´ÒôÅÅĞò¡£
     */

    int method = 0;

    // enableDesc == false, ²»ÆôÓÃµ¹ĞòÅÅĞò£¬·´Ö®ÆôÓÃ¡£
    boolean enableDesc = false;

    public int getMethod() {
        return this.method;
    }

    public void setMethod(int method) {
        this.method = method;
    }

    public boolean getEnableDesc() {
        return this.enableDesc;
    }

    public void setEnableDesc(boolean enableDesc) {
        this.enableDesc = enableDesc;
    }

    public String generateSortingSql() {
        String str = " ";

        switch (method) {
            case 1:
                str = str + "order by convert(reading using gbk)";
                break;
            case 2:
                str = str + "order by tail_symbol, reading_id";
                break;
            case 3:
                str = str + "order by tail_symbol, convert(reading using gbk)";
                break;
            default:
                str = str + "order by reading_id";
                break;
        }
        if(enableDesc == true) {
            str = str + " desc";
        }

        return str;
    }
}
