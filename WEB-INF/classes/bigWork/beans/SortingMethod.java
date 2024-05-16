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

public class SortingMethod {
    /* method == 0, 按主键 reading_id 排序。
     * method == 1, 按 reading 的拼音排序。
     * method == 2, 按尾字韵母 + reading_id 排序。
     * method == 3, 按尾字韵母 + reading 的拼音排序。
     */

    int method = 0;

    // enableDesc == false, 不启用倒序排序，反之启用。
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
