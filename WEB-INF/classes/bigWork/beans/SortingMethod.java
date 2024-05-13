package bigWork.beans;

public class SortingMethod {
    /* method == 0, ������ reading_id ����
     * method == 1, �� reading ��ƴ������
     * method == 2, ��β����ĸ + reading_id ����
     * method == 3, ��β����ĸ + reading ��ƴ������
     */

    int method = 0;

    // enableDesc == false, �����õ������򣬷�֮���á�
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
