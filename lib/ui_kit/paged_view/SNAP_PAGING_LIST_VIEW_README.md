Snap Paging ListView

## Mục đích
- Xây dựng common view có thể snap được các item trong đó

## Yêu cầu:
- Tạo ra 1 ListView có option snap hoặc normal (ko snap). Nếu tận dụng được class CommonPagedListView để tích hợp cả paging thì càng tốt.

## Cách xây dựng
Tạo ra một scroll physics để tính toán tốc độ vuốt và snap đến index đó

## Mô tả
- Thêm property snapping vào PagedListView
- Hỗ trợ Horizontal và Vertical
- Hỗ trợ snapping theo start, middle, end

## Link with description and example:
https://bitbucket.org/nal-solutions/nmtb-nals-mobile-team-brain/pull-requests/13