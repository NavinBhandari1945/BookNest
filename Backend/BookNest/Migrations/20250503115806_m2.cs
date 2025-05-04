using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BookNest.Migrations
{
    /// <inheritdoc />
    public partial class m2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ReviewInfos_BookInfos_BooksBookId",
                table: "ReviewInfos");

            migrationBuilder.DropForeignKey(
                name: "FK_ReviewInfos_UserInfos_UsersUserId",
                table: "ReviewInfos");

            migrationBuilder.DropIndex(
                name: "IX_ReviewInfos_BooksBookId",
                table: "ReviewInfos");

            migrationBuilder.DropIndex(
                name: "IX_ReviewInfos_UsersUserId",
                table: "ReviewInfos");

            migrationBuilder.DropColumn(
                name: "BooksBookId",
                table: "ReviewInfos");

            migrationBuilder.DropColumn(
                name: "UsersUserId",
                table: "ReviewInfos");

            migrationBuilder.CreateIndex(
                name: "IX_ReviewInfos_BookId",
                table: "ReviewInfos",
                column: "BookId");

            migrationBuilder.CreateIndex(
                name: "IX_ReviewInfos_UserId",
                table: "ReviewInfos",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_ReviewInfos_BookInfos_BookId",
                table: "ReviewInfos",
                column: "BookId",
                principalTable: "BookInfos",
                principalColumn: "BookId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ReviewInfos_UserInfos_UserId",
                table: "ReviewInfos",
                column: "UserId",
                principalTable: "UserInfos",
                principalColumn: "UserId",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ReviewInfos_BookInfos_BookId",
                table: "ReviewInfos");

            migrationBuilder.DropForeignKey(
                name: "FK_ReviewInfos_UserInfos_UserId",
                table: "ReviewInfos");

            migrationBuilder.DropIndex(
                name: "IX_ReviewInfos_BookId",
                table: "ReviewInfos");

            migrationBuilder.DropIndex(
                name: "IX_ReviewInfos_UserId",
                table: "ReviewInfos");

            migrationBuilder.AddColumn<int>(
                name: "BooksBookId",
                table: "ReviewInfos",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UsersUserId",
                table: "ReviewInfos",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ReviewInfos_BooksBookId",
                table: "ReviewInfos",
                column: "BooksBookId");

            migrationBuilder.CreateIndex(
                name: "IX_ReviewInfos_UsersUserId",
                table: "ReviewInfos",
                column: "UsersUserId");

            migrationBuilder.AddForeignKey(
                name: "FK_ReviewInfos_BookInfos_BooksBookId",
                table: "ReviewInfos",
                column: "BooksBookId",
                principalTable: "BookInfos",
                principalColumn: "BookId");

            migrationBuilder.AddForeignKey(
                name: "FK_ReviewInfos_UserInfos_UsersUserId",
                table: "ReviewInfos",
                column: "UsersUserId",
                principalTable: "UserInfos",
                principalColumn: "UserId");
        }
    }
}
