package bigWork.beans;

public class WordsSet {
    int         total;

    int[]       readingId;
    String[]    reading;
    int[]       readType;
    int[]       panelId;
    String[]    headSymbol;
    String[]    tailSymbol;

    // 按照获得的词条总数初始化词条集。
    public void init(int total) {
        this.total      = total;
        this.readingId  = new int[this.total + 1];
        this.reading    = new String[this.total + 1];
        this.readType   = new int[this.total + 1];
        this.panelId    = new int[this.total + 1];
        this.headSymbol = new String[this.total + 1];
        this.tailSymbol = new String[this.total + 1];
    }


    // 按索引号设置单条 readingId 记录。
    public int getReadingIdByIndex(int index) {
        return this.readingId[index];
    }

    public void setReadingIdByIndex(int index, int value) {
        this.readingId[index] = value;
    }

    // 按索引号设置单条 reading 记录。
    public String getReadingByIndex(int index) {
        return this.reading[index];
    }

    public void setReadingByIndex(int index, String value) {
        this.reading[index] = value;
    }

    // 按索引号设置单条 readType 记录。
    public int getReadTypeByIndex(int index) {
        return this.readType[index];
    }

    public void setReadTypeByIndex(int index, int value) {
        this.readType[index] = value;
    }

    // 按索引号设置单条 panelId 记录。
    public int getPanelIdByIndex(int index) {
        return panelId[index];
    }

    public void setPanelIdByIndex(int index, int value) {
        this.panelId[index] = value;
    }

    // 按索引号设置单条 headSymbol 记录。
    public String getHeadSymbolByIndex(int index) {
        return this.headSymbol[index];
    }

    public void setHeadSymbolByIndex(int index, String value) {
        this.headSymbol[index] = value;
    }

    // 按索引号设置单条 tailSymbol 记录。
    public String getTailSymbolByIndex(int index) {
        return this.tailSymbol[index];
    }

    public void setTailSymbolByIndex(int index, String value) {
        this.tailSymbol[index] = value;
    }



    // IDEA 生成的 getter 和 setter 方法的代码的起始。
    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int[] getReadingId() {
        return readingId;
    }

    public void setReadingId(int[] readingId) {
        this.readingId = readingId;
    }

    public String[] getReading() {
        return reading;
    }

    public void setReading(String[] reading) {
        this.reading = reading;
    }

    public int[] getReadType() {
        return readType;
    }

    public void setReadType(int[] readType) {
        this.readType = readType;
    }

    public int[] getPanelId() {
        return panelId;
    }

    public void setPanelId(int[] panelId) {
        this.panelId = panelId;
    }

    public String[] getHeadSymbol() {
        return headSymbol;
    }

    public void setHeadSymbol(String[] headSymbol) {
        this.headSymbol = headSymbol;
    }

    public String[] getTailSymbol() {
        return tailSymbol;
    }

    public void setTailSymbol(String[] tailSymbol) {
        this.tailSymbol = tailSymbol;
    }
    // IDEA 生成的 getter 和 setter 方法的代码的结束。
}