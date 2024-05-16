/**
 * ***.java: a Java file of Leisredragongame
 *
 * Leisredragongame is free software licensed under the GNU Affero General
 * Public License version 3 published by the Free Software Foundation and
 * without any warranty for liability or particular purpose.
 *
 * You can modify and/or redistribute it under the GNU Affero General Public
 * License version 3 or any later version you want.
 *
 * License file can be found in this repository; if not, please see
 * <https://www.gnu.org/licenses/agpl-3.0.txt>.
 */

package bigWork.beans;

public class InfoSet {
    // 1: num,			2: reading_id,  3: reading,
    // 4: read_type,	5: panel_id,    6: detail_text,
    // 7: head_symbol,  8: tail_symbol, 9: is_character
    // 不懂这些字段的含义的话，请提 issue。
    int     num = 0;
    int     readingId = 0;
    String  reading = new String();
    int     readType = 0;
    int     panelId = 0;
    String  detailText = new String();
    String  headSymbol = new String();
    String  tailSymbol = new String();
    int     isCharacter = -1;

    public void fastSet(
            int num, int readingId, String reading,
            int readType, int panelId, String detailText,
            String headSymbol, String tailSymbol, int isCharacter
    ) {
        this.num = num;
        this.readingId = readingId;
        this.reading = reading;
        this.readType = readType;
        this.panelId = panelId;
        this.detailText = detailText;
        this.headSymbol = headSymbol;
        this.tailSymbol = tailSymbol;
        this.isCharacter = isCharacter;
    }

    // idea 生成的 getter 和 setter 方法的代码的起始。
    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public int getReadingId() {
        return readingId;
    }

    public void setReadingId(int readingId) {
        this.readingId = readingId;
    }

    public String getReading() {
        return reading;
    }

    public void setReading(String reading) {
        this.reading = reading;
    }

    public int getReadType() {
        return readType;
    }

    public void setReadType(int readType) {
        this.readType = readType;
    }

    public int getPanelId() {
        return panelId;
    }

    public void setPanelId(int panelId) {
        this.panelId = panelId;
    }

    public String getDetailText() {
        return detailText;
    }

    public void setDetailText(String detailText) {
        this.detailText = detailText;
    }

    public String getHeadSymbol() {
        return headSymbol;
    }

    public void setHeadSymbol(String headSymbol) {
        this.headSymbol = headSymbol;
    }

    public String getTailSymbol() {
        return tailSymbol;
    }

    public void setTailSymbol(String tailSymbol) {
        this.tailSymbol = tailSymbol;
    }

    public int getIsCharacter() {
        return isCharacter;
    }

    public void setIsCharacter(int isCharacter) {
        this.isCharacter = isCharacter;
    }
    // IdEA 生成的 getter 和 setter 方法的代码的结束。
}
