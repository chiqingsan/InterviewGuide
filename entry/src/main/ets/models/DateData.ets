
/**
 * 返回数据
 */
export interface clockInData {
  /**
   * 连续签到天数
   */
  clockinNumbers: number;
  /**
   * 签到信息
   */
  clockins: checkInTime[];
  /**
   * 当天是否签到
   */
  flag: boolean;
  /**
   * 累计签到天数
   */
  totalClockinNumber: number;
}

export interface checkInTime {
  /**
   * 签到时间
   */
  createdAt: string;
  id: string;
}